data "aws_availability_zones" "available" {}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "EniCreation"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces"
    ]
    resources = ["*"]
  }
}
