################################################################################
# VPC Endpoints Module
################################################################################

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "6.0.1"

  vpc_id = local.workspace["vpc_id"]

  create_security_group      = local.workspace["create_security_group"]
  security_group_name_prefix = local.workspace["security_group_name_prefix"]
  security_group_description = local.workspace["security_group_description"]
  security_group_rules       = local.workspace["security_group_rules"]

  endpoints = local.workspace["endpoints"]

  tags = local.workspace["tags"]
}
