module "vpc" {
  source = "../modules/base/vpc"

  vpc_name = format("%s-%s-%s", "url-monitoring", "vpc", var.env)
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  cidr_range = "10.0.0.0/16"

  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "lambda" {
  source = "../modules/app/lambda"

  lambda_api_functions = local.functions

  lambda_layer_name      = "url-monitoring-layer-${var.env}"
  local_existing_package = "../build/lambda/layer.zip"

  subnet_ids        = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.id
  cw_logs_retention = 30
}

module "lambda_role" {
  source = "../modules/base/iam"

  role_name             = format("%s-%s", "url-monitoring", "lambda-role")
  trusted_role_services = ["lambda.amazonaws.com"]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]
  policy      = data.aws_iam_policy_document.lambda.json
  policy_name = format("%s-%s", "url-monitoring", "lambda-policy")
}

module "apigw" {
  source = "../modules/app/api_gateway"

  apigw_name = format("%s-%s-%s", "url-monitoring", "apigw", var.env)
  lambda_arn = module.lambda.lambda_functions_arn["view_status"]

  lambda_permission = {
    view_status = {
      lambda_name = module.lambda.lambda_functions_name["view_status"]
      principal   = "apigateway.amazonaws.com"
      qualifier   = null
    }
  }
}

module "s3" {
  for_each = local.s3_buckets

  source = "../modules/base/s3"

  bucket_name      = each.value.name
  acl              = each.value.acl
  object_ownership = each.value.object_ownership
  attach_lb_log    = each.value.attach_lb_log
}

module "dynamodb" {
  for_each = local.tables

  source             = "../modules/app/dynamodb"
  table_name         = each.value.name
  partition_key      = each.value.partition_key
  partition_key_type = each.value.partition_key_type
  sort_key           = each.value.sort_key
  sort_key_type      = each.value.sort_key_type
  billing_mode       = each.value.billing_mode
}

module "eventbridge" {
  source = "../modules/base/eventbridge"

  schedule_name = format("%s-%s-%s", "url-monitoring", "schedule", var.env)
  lambda_arns = [
    module.lambda.lambda_functions_arn["monitor_url"]
  ]
}
