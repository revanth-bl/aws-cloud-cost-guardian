# AWS Cloud Cost Guardian 🚀

> **Automated AWS Cost Optimization using AWS Lambda, EventBridge, CloudWatch, SNS, Terraform, and GitHub Actions.**

![Architecture](architecture/architecture.png)

---

# 📖 Overview

AWS Cloud Cost Guardian is a serverless automation project that helps reduce unnecessary AWS storage costs by identifying and deleting unused EBS snapshots.

The solution runs automatically on a schedule, publishes CloudWatch metrics, sends email reports using SNS, and is deployed through a GitHub Actions CI/CD pipeline. Infrastructure is managed with Terraform.

---
> [!IMPORTANT]
> **Project Status**
>
> This project has been successfully completed and validated. To prevent ongoing AWS costs, all cloud resources (Lambda, IAM Roles, EventBridge Scheduler, SNS Topic, CloudWatch resources, and test infrastructure) were removed after testing.
>
> The repository remains fully reproducible using the included Terraform configuration and deployment guide.

# ✨ Features

- Automated EBS snapshot cleanup
- Dry Run mode
- Keep=True tag protection
- CloudWatch Metrics & Dashboard
- CloudWatch Alarms
- SNS Email Notifications
- EventBridge Scheduling
- Terraform Infrastructure as Code
- GitHub Actions CI/CD

---

# 🏗 Architecture

```text
GitHub
   │
GitHub Actions
   │
AWS Lambda
   │
EC2 / EBS
   ├── Delete Unused Snapshots
   ├── CloudWatch Metrics
   └── SNS Email
```

---

# ☁ AWS Services

| Service | Purpose |
|----------|---------|
| Lambda | Automation |
| EC2 | Volume discovery |
| EBS | Snapshot cleanup |
| EventBridge | Scheduling |
| SNS | Email |
| CloudWatch | Monitoring |
| IAM | Permissions |
| Terraform | IaC |
| GitHub Actions | CI/CD |

---

# 📂 Project Structure

```text
aws-cloud-cost-guardian/
├── .github/workflows/deploy.yml
├── architecture/
├── docs/
├── lambda/
├── screenshots/
├── terraform/
└── README.md
```

---

# 🚀 Deployment Blueprint

Follow these steps to deploy the AWS Cloud Cost Guardian project from scratch.

---

## 📍 Step 1 — Create an IAM Policy

Navigate to:

AWS Console → IAM → Policies → Create Policy

### Permissions Required

- Amazon EC2
- Amazon SNS
- Amazon CloudWatch
- Amazon CloudWatch Logs

### Recommended Permissions

- ec2:DescribeSnapshots
- ec2:DeleteSnapshot
- ec2:DescribeInstances
- cloudwatch:PutMetricData
- sns:Publish
- logs:CreateLogGroup
- logs:CreateLogStream
- logs:PutLogEvents

Save the policy as:

```
CloudCostGuardianPolicy
```

---

## 📍 Step 2 — Create an IAM Role

Navigate to:

AWS Console → IAM → Roles → Create Role

Choose

```
Trusted Entity:
AWS Service

Use Case:
Lambda
```

Attach the following policies

- AWSLambdaBasicExecutionRole
- CloudCostGuardianPolicy

Role Name

```
CloudCostGuardianRole
```

---

## 📍 Step 3 — Create the Lambda Function

Navigate to

AWS Console → Lambda → Create Function

Configuration

```
Function Name
aws-cost-optimization-toolkit

Runtime
Python 3.13

Architecture
x86_64

Execution Role
Use Existing Role

CloudCostGuardianRole
```

Click

```
Create Function
```

---

## 📍 Step 4 — Upload the Python Code

Open

```
lambda/
```

Copy the contents of

```
lambda_function.py
```

Paste into the Lambda editor

Click

```
Deploy
```

---

## 📍 Step 5 — Configure Environment Variables

Lambda

Configuration

↓

Environment Variables

Add

| Key | Value |
|------|-------|
| DRY_RUN | False |
| KEEP_TAG_KEY | Keep |
| KEEP_TAG_VALUE | True |
| SNS_TOPIC_ARN | Your SNS Topic ARN |

Save

---

## 📍 Step 6 — Create an SNS Topic

Navigate to

AWS Console

↓

Amazon SNS

↓

Create Topic

Configuration

```
Type
Standard

Name
cloud-cost-guardian-topic
```

Click

```
Create Topic
```

---

## 📍 Step 7 — Create an Email Subscription

Inside the SNS Topic

Click

```
Create Subscription
```

Protocol

```
Email
```

Endpoint

```
your-email@example.com
```

Click

```
Create Subscription
```

Open your inbox

Click

```
Confirm Subscription
```

---

## 📍 Step 8 — Configure Lambda with SNS

Copy

```
Topic ARN
```

Example

```
arn:aws:sns:us-east-1:123456789012:cloud-cost-guardian-topic
```

Paste it into

Lambda

↓

Environment Variables

↓

SNS_TOPIC_ARN

Save

Deploy

---

## 📍 Step 9 — Test the Lambda Function

Lambda

↓

Test

↓

Create New Test Event

Name

```
TestCleanup
```

Event JSON

```json
{}
```

Click

```
Test
```

Verify

✅ Lambda executes successfully

✅ CloudWatch Logs generated

✅ Email report received

---

## 📍 Step 10 — Create CloudWatch Custom Metrics

Run the Lambda once.

Navigate to

AWS Console

↓

CloudWatch

↓

Metrics

↓

CloudCostGuardian

Verify these metrics exist

- SnapshotsScanned
- SnapshotsDeleted
- SnapshotsSkipped
- CleanupErrors

---

## 📍 Step 11 — Create CloudWatch Alarm

Navigate to

CloudWatch

↓

Alarms

↓

Create Alarm

Metric

```
CleanupErrors
```

Condition

```
Greater Than

Threshold = 0
```

Notification

```
SNS Topic

cloud-cost-guardian-topic
```

Alarm Name

```
CloudCostGuardian-CleanupErrors
```

Create Alarm

---

## 📍 Step 12 — Create EventBridge Scheduler

Navigate to

AWS Console

↓

Amazon EventBridge

↓

Scheduler

↓

Create Schedule

Configuration

```
Name

CloudCostGuardianScheduler
```

Schedule

```
Rate

Every 5 Minutes (Testing)

or

Daily (Production)
```

Target

```
AWS Lambda

aws-cost-optimization-toolkit
```

Execution Role

```
Auto Create Role
```

Create Schedule

---

## 📍 Step 13 — Verify Automation

Wait for the scheduled execution.

Verify

✅ Lambda Invocations

✅ CloudWatch Logs

✅ CloudWatch Metrics

✅ SNS Email Notifications

✅ Snapshot Cleanup

---

## 📍 Step 14 — Infrastructure as Code

Terraform Folder

```
terraform/

├── provider.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── iam.tf
├── lambda.tf
├── sns.tf
├── cloudwatch.tf
├── eventbridge.tf
└── outputs.tf
```

Initialize

```bash
terraform init
```

Format

```bash
terraform fmt
```

Validate

```bash
terraform validate
```

Deploy

```bash
terraform apply
```

---

## 📍 Step 15 — GitHub Actions CI/CD

Repository Structure

```
.github/

└── workflows

    └── deploy.yml
```

Required GitHub Secrets

```
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION
```

Workflow

```
Developer

↓

Git Push

↓

GitHub Actions

↓

Create Deployment Package

↓

Deploy Lambda

↓

Wait for Deployment

↓

Deployment Successful
```

Every push to the **main** branch automatically deploys the latest Lambda code.

---

# 📊 Complete Project Architecture

```
                     Developer
                         │
                         ▼
                  GitHub Repository
                         │
                         ▼
                 GitHub Actions CI/CD
                         │
                         ▼
                 Deploy Lambda Function
                         │
                         ▼
                Amazon EventBridge Scheduler
                         │
                         ▼
              AWS Lambda Cost Guardian
                         │
          ┌──────────────┴──────────────┐
          │                             │
          ▼                             ▼
   Amazon EC2 / EBS             Amazon CloudWatch
   Discover Snapshots         Custom Metrics & Logs
          │
          ▼
 Delete Unused Snapshots
          │
          ▼
      Amazon SNS
          │
          ▼
     Email Notification
```

---

# 🧹 Cleanup

To avoid unnecessary AWS charges after testing, delete the following resources:

- EventBridge Scheduler
- Lambda Function
- IAM Role
- Custom IAM Policy
- SNS Topic
- CloudWatch Alarm
- CloudWatch Log Group
- CloudWatch Custom Metrics (optional)
- EC2 Test Instance
- EBS Volume
- Test Snapshots

---

# ✅ Expected Results

- Automated EBS snapshot cleanup
- Email notification after every execution
- CloudWatch metrics published
- CloudWatch alarm on cleanup failures
- EventBridge scheduled execution
- Infrastructure managed with Terraform
- Automatic deployment through GitHub Actions

---

# 📸 Screenshots

Replace the placeholders below with your screenshots.

- Lambda Function
- IAM Role
- SNS Topic
- EventBridge Scheduler
- CloudWatch Dashboard
- CloudWatch Alarm
- GitHub Actions Success

---

# 🔄 CI/CD

```text
Developer
   │
Git Push
   │
GitHub Actions
   │
Package Lambda
   │
Deploy Lambda
```

---

# 🧪 Testing

- Lambda Test Event
- EventBridge Trigger
- CloudWatch Metrics
- SNS Email
- GitHub Actions Deployment

---

# 📈 Future Improvements

- Multi-region support
- Slack notifications
- AWS Cost Explorer integration
- AWS Organizations support

---

# 👨‍💻 Author

**Revanth B L**

GitHub: https://github.com/revanth-bl
