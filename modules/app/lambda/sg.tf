module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  for_each = var.lambda_api_functions

  name        = "${each.value.name}-sg"
  description = "Managed by Terraform"

  vpc_id = var.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Egress - Allow all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
