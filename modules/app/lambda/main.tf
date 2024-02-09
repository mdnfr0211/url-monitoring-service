module "lambda_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "5.2.0"

  create_function = false
  create_layer    = true
  create_package  = false

  layer_name              = var.lambda_layer_name
  description             = "Dependency layer"
  compatible_runtimes     = ["python3.12"]
  runtime                 = "python3.12"
  ignore_source_code_hash = true
  local_existing_package  = var.local_existing_package
}

module "lambda_functions" {
  for_each = var.lambda_api_functions

  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.1"

  function_name         = each.value.name
  description           = ""
  handler               = each.value.handler
  runtime               = each.value.runtime
  memory_size           = each.value.memory_size
  timeout               = each.value.timeout
  create_role           = false
  lambda_role           = each.value.iam_role_arn
  environment_variables = each.value.environment_variables

  create_package          = each.value.create_package
  ignore_source_code_hash = each.value.ignore_source_code_hash
  local_existing_package  = each.value.api_code
  vpc_subnet_ids          = var.subnet_ids
  vpc_security_group_ids = [
    module.security_group[each.key].security_group_id
  ]

  attach_tracing_policy = true
  tracing_mode          = "Active"

  cloudwatch_logs_retention_in_days = var.cw_logs_retention

  publish = false

  layers = [
    module.lambda_layer.lambda_layer_arn
  ]
}
