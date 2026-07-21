# ==========================================
# AWS Configuration
# ==========================================

aws_region = "us-east-1"

# ==========================================
# Lambda
# ==========================================

lambda_function_name = "aws-cost-optimization-toolkit"

lambda_runtime = "python3.14"

lambda_handler = "lambda_function.lambda_handler"

# ==========================================
# IAM
# ==========================================

iam_role_name = "aws-cost-optimization-toolkit-role"

# ==========================================
# SNS
# ==========================================

sns_topic_name = "cloud-cost-guardian-topic"

notification_email = "revanthrevanthbl@gmail.com"

# ==========================================
# EventBridge
# ==========================================

schedule_expression = "rate(1 day)"