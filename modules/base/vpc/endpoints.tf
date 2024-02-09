module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.5.1"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = flatten(
        [
          length(var.intra_subnets) > 0 ? module.vpc.intra_route_table_ids : [],
          length(var.private_subnets) > 0 ? module.vpc.private_route_table_ids : [],
          length(var.public_subnets) > 0 ? module.vpc.public_route_table_ids : []
        ]
      )
      policy = data.aws_iam_policy_document.endpoint_policy.json
      tags   = { Name = "s3-vpc-endpoint" }
    },
    dynamodb = {
      service      = "dynamodb"
      service_type = "Gateway"
      route_table_ids = flatten(
        [
          length(var.intra_subnets) > 0 ? module.vpc.intra_route_table_ids : [],
          length(var.private_subnets) > 0 ? module.vpc.private_route_table_ids : [],
          length(var.public_subnets) > 0 ? module.vpc.public_route_table_ids : []
        ]
      )
      policy = data.aws_iam_policy_document.endpoint_policy.json
      tags   = { Name = "dynamodb-vpc-endpoint" }
    }
  }

  tags = var.tags
}
