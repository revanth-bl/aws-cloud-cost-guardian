# ==========================================
# Package Lambda Function
# ==========================================

resource "aws_lambda_function" "cost_guardian" {

  function_name = var.lambda_function_name

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.lambda_role.arn
  handler = var.lambda_handler
  runtime = var.lambda_runtime

  timeout     = 60
  memory_size = 128

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.cost_guardian_topic.arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.basic_execution,
    aws_iam_role_policy_attachment.custom_policy_attachment
  ]

  tags = {
    Name    = "AWS Cloud Cost Guardian"
    Project = "Cloud Cost Guardian"
  }
}