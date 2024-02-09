output "lambda_functions_invoke_arn" {
  description = "Map of lambda function invoke ARNs used by APIGW"
  value = tomap({
    for k, f in module.lambda_functions : k => f.lambda_function_invoke_arn
  })
}

output "lambda_functions_arn" {
  description = "Map of lambda function ARNs"
  value = tomap({
    for k, f in module.lambda_functions : k => f.lambda_function_arn
  })
}

output "lambda_functions_name" {
  description = "Map of lambda function names"
  value = tomap({
    for k, f in module.lambda_functions : k => f.lambda_function_name
  })
}
