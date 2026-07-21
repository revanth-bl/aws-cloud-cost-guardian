# ==========================================
# AWS Region
# ==========================================
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# ==========================================
# Lambda Function Name
# ==========================================
variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
  default     = "aws-cost-optimization-toolkit"
}

# ==========================================
# IAM Role Name
# ==========================================
variable "iam_role_name" {
  description = "IAM Role Name"
  type        = string
  default     = "aws-cost-optimization-toolkit-role"
}

# ==========================================
# SNS Topic Name
# ==========================================
variable "sns_topic_name" {
  description = "SNS Topic Name"
  type        = string
  default     = "cloud-cost-guardian-topic"
}

# ==========================================
# Email Subscription
# ==========================================
variable "notification_email" {
  description = "Email address for SNS notifications"
  type        = string
  default     = "revanthrevanthbl@gmail.com"
}

# ==========================================
# EventBridge Schedule
# ==========================================
variable "schedule_expression" {
  description = "EventBridge Schedule"
  type        = string
  default     = "rate(1 day)"
}

# ==========================================
# Lambda Runtime
# ==========================================
variable "lambda_runtime" {
  description = "Lambda Runtime"
  type        = string
  default     = "python3.14"
}

# ==========================================
# Lambda Handler
# ==========================================
variable "lambda_handler" {
  description = "Lambda Handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}