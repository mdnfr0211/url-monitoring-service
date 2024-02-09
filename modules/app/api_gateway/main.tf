module "apigateway_v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.2"

  name          = var.apigw_name
  description   = ""
  protocol_type = "HTTP"

  create_api_domain_name = false

  cors_configuration = {
    allow_headers = []
    allow_methods = []
    allow_origins = []
  }

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.log_group.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  integrations = {
    "GET /" = {
      lambda_arn             = var.lambda_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 10000
    }

    "GET /status" = {
      lambda_arn             = var.lambda_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 10000
    }
  }

  authorizers = {}

  tags = {
    Name = var.apigw_name
  }
}

resource "random_string" "id" {
  length           = 8
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_lambda_permission" "apigw_lambda" {
  for_each = var.lambda_permission

  statement_id  = random_string.id.result
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_name
  principal     = each.value.principal
  source_arn    = "${module.apigateway_v2.apigatewayv2_api_execution_arn}/*"
  qualifier     = each.value.qualifier
}
