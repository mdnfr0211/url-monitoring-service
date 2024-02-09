resource "aws_cloudwatch_log_group" "log_group" {

  name              = "${var.apigw_name}-log-group"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.waf_log_encryption.arn
}

resource "aws_kms_key" "waf_log_encryption" {
  description             = "WAF logs CMK"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key_policy.json
}
