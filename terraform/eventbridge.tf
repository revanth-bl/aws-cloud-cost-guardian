# ==========================================
# EventBridge Rule
# ==========================================

resource "aws_cloudwatch_event_rule" "cost_guardian_schedule" {

  name = "daily-ebs-snapshot-cleanup"

  description = "Triggers AWS Cost Guardian Lambda daily"

  schedule_expression = var.schedule_expression

}

# ==========================================
# EventBridge Target
# ==========================================

resource "aws_cloudwatch_event_target" "lambda_target" {

  rule = aws_cloudwatch_event_rule.cost_guardian_schedule.name

  arn = aws_lambda_function.cost_guardian.arn

}

# ==========================================
# Allow EventBridge to Invoke Lambda
# ==========================================

resource "aws_lambda_permission" "allow_eventbridge" {

  statement_id = "AllowExecutionFromEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.cost_guardian.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.cost_guardian_schedule.arn

}