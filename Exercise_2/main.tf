provider "aws" {
  access_key = ""
  secret_key = ""
  region     = var.aws_region
}

# Cloudwatch configuration
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_func_name}"
  retention_in_days = 3
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name = "lambda_logs_policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Lambda role configuration
resource "aws_iam_role" "lambda_iam" {
  name               = "lambda_iam"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_iam.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}

# Lambda function
resource "aws_lambda_function" "greeting" {
  function_name    = var.lambda_func_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "${var.lambda_func_name}.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_iam.arn

  environment {
    variables = {
      greeting = "Hello World!"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${var.lambda_func_name}.py"
  output_path = var.lambda_output_path
}