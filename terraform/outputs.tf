# ==========================================
# Lambda Function
# ==========================================

output "lambda_function_name" {
  description = "AWS Lambda Function Name"
  value       = aws_lambda_function.cost_guardian.function_name
}

output "lambda_function_arn" {
  description = "AWS Lambda Function ARN"
  value       = aws_lambda_function.cost_guardian.arn
}

# ==========================================
# IAM Role
# ==========================================

output "iam_role_arn" {
  description = "IAM Role ARN"
  value       = aws_iam_role.lambda_role.arn
}

# ==========================================
# SNS
# ==========================================

output "sns_topic_arn" {
  description = "SNS Topic ARN"
  value       = aws_sns_topic.cost_guardian_topic.arn
}

# ==========================================
# EventBridge
# ==========================================

output "eventbridge_rule_name" {
  description = "EventBridge Rule Name"
  value       = aws_cloudwatch_event_rule.cost_guardian_schedule.name
}

# ==========================================
# CloudWatch Alarm
# ==========================================

output "cloudwatch_alarm_name" {
  description = "CloudWatch Alarm Name"
  value       = aws_cloudwatch_metric_alarm.cleanup_errors.alarm_name
}