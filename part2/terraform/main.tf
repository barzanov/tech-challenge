resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Add minimum permissions only.
resource "aws_iam_policy" "lambda_vpc_policy" {
  name        = "${var.name}-policy"
  description = "Allows Lambda to read VPC and Subnet info"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "dynamodb:PutItem",
          "dynamodb:DescribeTable"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_vpc_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_vpc_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_basic_lambda_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "list_vpcs" {
  filename         = "${path.module}/lambda/function.zip"
  function_name    = var.name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/lambda/function.zip")
  timeout          = 10
}

resource "aws_dynamodb_table" "vpc_subnet_table" {
  name         = var.table_name
  hash_key     = "VpcId"
  range_key    = "Subnets"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "VpcId"
    type = "S"
  }

  attribute {
    name = "Subnets"
    type = "S"
  }
}
