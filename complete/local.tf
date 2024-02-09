locals {
  functions = {
    monitor_url = {
      name                    = "monitor-url-function-${var.env}"
      handler                 = "app.lambda_handler"
      runtime                 = "python3.12"
      iam_role_arn            = module.lambda_role.iam_role_arn
      memory_size             = 128
      timeout                 = 30
      create_package          = false
      ignore_source_code_hash = true
      api_code                = "../build/lambda/monitor_urls/code.zip"
      environment_variables = {
        "TABLE_NAME"        = module.dynamodb["log"].table_name
        "ASSET_BUCKET_NAME" = module.s3["asset"].bucket_id
        "OBJECT_KEY"        = "url-monitoring.csv"
      }
    }
    view_status = {
      name                    = "view-status-function-${var.env}"
      handler                 = "app.lambda_handler"
      runtime                 = "python3.12"
      iam_role_arn            = module.lambda_role.iam_role_arn
      memory_size             = 128
      timeout                 = 30
      create_package          = false
      ignore_source_code_hash = true
      api_code                = "../build/lambda/view_status/code.zip"
      environment_variables = {
        "TABLE_NAME"        = module.dynamodb["log"].table_name
        "ASSET_BUCKET_NAME" = module.s3["asset"].bucket_id
        "OBJECT_KEY"        = "url-monitoring.csv"
      }
    }
  }

  s3_buckets = {
    asset = {
      name             = "url-monitoring-asset-bucket-${var.env}"
      object_ownership = "BucketOwnerEnforced"
      acl              = null
      attach_lb_log    = false
    }
  }

  tables = {
    log = {
      name               = "url-monitoring-log-table-${var.env}"
      partition_key      = "urls"
      partition_key_type = "S"
      sort_key           = "timestamp"
      sort_key_type      = "S"
      billing_mode       = "PROVISIONED"
    }
  }
}
