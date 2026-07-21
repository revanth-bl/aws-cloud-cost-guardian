# ==========================================
# AWS Provider
# ==========================================

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "AWS Cloud Cost Guardian"
      Environment = "Production"
      ManagedBy   = "Terraform"
      Owner       = "Revanth"
    }
  }
}

# ==========================================
# Archive Provider
# ==========================================

data "archive_file" "lambda_zip" {
  type = "zip"

  source_file = "${path.module}/../lambda/lambda_function.py"

  output_path = "${path.module}/lambda_function.zip"
}