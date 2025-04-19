output "lambda_function_name" {
  value = aws_lambda_function.list_vpcs.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.list_vpcs.arn
}