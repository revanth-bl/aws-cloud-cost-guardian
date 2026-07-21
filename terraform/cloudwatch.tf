# ==========================================
# CloudWatch Dashboard
# ==========================================

resource "aws_cloudwatch_dashboard" "cost_guardian_dashboard" {

  dashboard_name = "AWS-Cost-Guardian-Dashboard"

  dashboard_body = jsonencode({

    widgets = [

      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "Snapshots Scanned",

          "view" : "singleValue",

          "metrics" : [
            [
              "AWS/CloudCostGuardian",
              "SnapshotsScanned"
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Sum"
        }
      },

      {
        "type" : "metric",
        "x" : 12,
        "y" : 0,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "Snapshots Deleted",

          "view" : "singleValue",

          "metrics" : [
            [
              "AWS/CloudCostGuardian",
              "SnapshotsDeleted"
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Sum"
        }
      },

      {
        "type" : "metric",
        "x" : 0,
        "y" : 6,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "Snapshots Skipped",

          "view" : "singleValue",

          "metrics" : [
            [
              "AWS/CloudCostGuardian",
              "SnapshotsSkipped"
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Sum"
        }
      },

      {
        "type" : "metric",
        "x" : 12,
        "y" : 6,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "Cleanup Errors",

          "view" : "singleValue",

          "metrics" : [
            [
              "AWS/CloudCostGuardian",
              "CleanupErrors"
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Sum"
        }
      }

    ]
  })
}

# ==========================================
# CloudWatch Alarm
# ==========================================

resource "aws_cloudwatch_metric_alarm" "cleanup_errors" {

  alarm_name = "AWS-Cost-Guardian-CleanupErrors-Alarm"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "CleanupErrors"

  namespace = "AWS/CloudCostGuardian"

  period = 300

  statistic = "Sum"

  threshold = 0

  alarm_description = "Triggers when AWS Cost Guardian encounters cleanup errors."

  treat_missing_data = "missing"

  alarm_actions = [
    aws_sns_topic.cost_guardian_topic.arn
  ]
}