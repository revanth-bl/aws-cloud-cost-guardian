# ==========================================
# SNS Topic
# ==========================================

resource "aws_sns_topic" "cost_guardian_topic" {

  name = var.sns_topic_name

}

# ==========================================
# Email Subscription
# ==========================================

resource "aws_sns_topic_subscription" "email_subscription" {

  topic_arn = aws_sns_topic.cost_guardian_topic.arn

  protocol = "email"

  endpoint = var.notification_email

}