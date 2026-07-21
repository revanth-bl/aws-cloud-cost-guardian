# AWS Cloud Cost Guardian 🚀

Automated AWS cost optimization solution that identifies and removes unused EBS snapshots using AWS Lambda.

## 📌 Problem Statement

AWS environments often accumulate unused EBS snapshots after EC2 instances are terminated.

These unused resources continue generating storage costs.

Cloud Cost Guardian automatically detects stale snapshots, removes unnecessary resources, and sends a cleanup report through email.

---

# 🏗 Architecture


![Architecture](architecture/architecture.png)


Workflow:

1. EventBridge triggers Lambda based on schedule.
2. Lambda scans AWS EBS snapshots.
3. Lambda identifies unused snapshots.
4. Unused snapshots are deleted.
5. Execution metrics are stored in CloudWatch.
6. SNS sends cleanup report through email.


---

# ☁ AWS Services Used

| Service | Purpose |
|-|-|
| AWS Lambda | Automation logic |
| Amazon EC2 | Source of EBS snapshots |
| Amazon EBS | Snapshot management |
| Amazon EventBridge | Scheduled execution |
| Amazon SNS | Email notifications |
| Amazon CloudWatch | Logs and monitoring |
| AWS IAM | Permissions management |


---

# ⚙ Features

✅ Automated snapshot cleanup

✅ Dry-run testing mode

✅ Protected snapshots using tags

✅ Scheduled execution

✅ Email notification reports

✅ CloudWatch logging


---

# 🚀 Deployment Steps

## 1. Create Lambda Function

Upload Python cleanup script:
