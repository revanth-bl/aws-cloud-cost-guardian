# ==========================================
# IAM Role for Lambda
# ==========================================

resource "aws_iam_role" "lambda_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ==========================================
# IAM Policy for Lambda
# ==========================================

resource "aws_iam_policy" "lambda_policy" {

  name        = "aws-cost-guardian-policy"
  description = "IAM Policy for AWS Cost Guardian Lambda"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeSnapshots",
          "ec2:DeleteSnapshot",
          "ec2:DescribeInstances"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "sns:Publish"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "cloudwatch:PutMetricData"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }

    ]

  })
}

# ==========================================
# Attach Custom Policy
# ==========================================

resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# ==========================================
# Attach AWS Managed Policy
# ==========================================

resource "aws_iam_role_policy_attachment" "basic_execution" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}