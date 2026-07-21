
import boto3
import logging
import json
import os
from botocore.exceptions import ClientError
from datetime import datetime

DRY_RUN = False
KEEP_TAG_KEY = "Keep"
KEEP_TAG_VALUE = "True"

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client("ec2")
sns = boto3.client("sns")
cloudwatch = boto3.client("cloudwatch")


def publish_metrics(scanned, deleted, skipped, errors):
    cloudwatch.put_metric_data(
        Namespace="CloudCostGuardian",
        MetricData=[
            {"MetricName":"SnapshotsScanned","Value":scanned,"Unit":"Count"},
            {"MetricName":"SnapshotsDeleted","Value":deleted,"Unit":"Count"},
            {"MetricName":"SnapshotsSkipped","Value":skipped,"Unit":"Count"},
            {"MetricName":"CleanupErrors","Value":errors,"Unit":"Count"},
        ],
    )


def send_email(summary):
    if not SNS_TOPIC_ARN:
        logger.warning("SNS_TOPIC_ARN not configured.")
        return

    status = "SUCCESS" if summary["Errors"] == 0 else "FAILED"

    message = f"""
AWS COST OPTIMIZATION REPORT

Execution Time:
{datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")}

Snapshots Scanned : {summary['Snapshots Scanned']}
Snapshots Deleted : {summary['Snapshots Deleted']}
Snapshots Skipped : {summary['Snapshots Skipped']}
Errors            : {summary['Errors']}
Dry Run           : {summary['Dry Run']}

Status : {status}

Generated automatically by Cloud Cost Guardian.
"""

    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="AWS Cost Optimization Report",
        Message=message,
    )


def lambda_handler(event, context):
    logger.info("=" * 60)
    logger.info("AWS Cost Optimization Started")
    logger.info("=" * 60)

    scanned = deleted = skipped = errors = 0

    try:
        snapshots = ec2.describe_snapshots(OwnerIds=["self"])["Snapshots"]

        instances = ec2.describe_instances(
            Filters=[
                {
                    "Name": "instance-state-name",
                    "Values": ["running", "stopped"],
                }
            ]
        )

        active_volume_ids = set()

        for reservation in instances["Reservations"]:
            for instance in reservation["Instances"]:
                for mapping in instance.get("BlockDeviceMappings", []):
                    ebs = mapping.get("Ebs")
                    if ebs:
                        active_volume_ids.add(ebs["VolumeId"])

        logger.info(f"Active Volumes: {len(active_volume_ids)}")

        for snapshot in snapshots:
            scanned += 1

            snapshot_id = snapshot["SnapshotId"]
            volume_id = snapshot.get("VolumeId")

            keep = any(
                tag["Key"] == KEEP_TAG_KEY and tag["Value"] == KEEP_TAG_VALUE
                for tag in snapshot.get("Tags", [])
            )

            if keep:
                skipped += 1
                logger.info(f"Skipping {snapshot_id}")
                continue

            if volume_id not in active_volume_ids:
                logger.info(f"Deleting {snapshot_id}")
                if not DRY_RUN:
                    ec2.delete_snapshot(SnapshotId=snapshot_id)
                deleted += 1
            else:
                skipped += 1
                logger.info(f"Keeping {snapshot_id}")

        summary = {
            "Snapshots Scanned": scanned,
            "Snapshots Deleted": deleted,
            "Snapshots Skipped": skipped,
            "Errors": errors,
            "Dry Run": DRY_RUN,
        }

        publish_metrics(scanned, deleted, skipped, errors)
        send_email(summary)

        return {
            "statusCode": 200,
            "body": json.dumps(summary),
        }

    except (ClientError, Exception) as e:
        errors += 1
        logger.exception("Execution failed")

        summary = {
            "Snapshots Scanned": scanned,
            "Snapshots Deleted": deleted,
            "Snapshots Skipped": skipped,
            "Errors": errors,
            "Dry Run": DRY_RUN,
        }

        publish_metrics(scanned, deleted, skipped, errors)
        send_email(summary)

        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
