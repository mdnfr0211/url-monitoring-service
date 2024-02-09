module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.2.2"

  create_bus  = false
  create_role = true

  role_name = "${var.schedule_name}-iam-role"

  attach_lambda_policy = true
  lambda_target_arns   = var.lambda_arns

  schedules = {
    lambda-cron = {
      name                = var.schedule_name
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(5 minutes)"
      timezone            = "Asia/Singapore"
      arn                 = var.lambda_arns[0]
    }
  }
}
