# Setup Guide

## Prerequisites

- AWS Account
- IAM permissions
- Python knowledge


## AWS Setup

### Lambda

Create Lambda function.

Runtime:

Python 3.14


Upload:

lambda_function.py


---

## IAM Permissions

Attach:

- EC2 permissions
- SNS Publish
- CloudWatch Logs


---

## SNS Setup

Create topic:

cloud-cost-guardian-topic


Create email subscription.

Confirm email.


---

## EventBridge

Create schedule.

Connect target:

AWS Lambda


---

## Testing

Run Lambda test event.

Verify:

- CloudWatch logs
- SNS email
- Snapshot cleanup