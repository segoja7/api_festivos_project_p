################################################################################
# VPC Module "bucket-s3-udea-project-dev-71d2a3a4"
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = local.workspace["vpc_name"]
  cidr = local.workspace["vpc_cidr"]

  azs = local.workspace["availability_zones"]

  # Subnets públicas para el balanceador de carga
  public_subnets = local.workspace["public_subnets"]
  
  # Subnets privadas para aplicaciones (EKS)
  private_subnets = local.workspace["private_subnets"]
  
  # Subnets privadas para base de datos (RDS)
  database_subnets = local.workspace["database_subnets"]

  # Configuración de NAT Gateway
  enable_nat_gateway = local.workspace["enable_nat_gateway"]
  single_nat_gateway = local.workspace["single_nat_gateway"]
  enable_vpn_gateway = local.workspace["enable_vpn_gateway"]

  # Configuración de DNS
  enable_dns_hostnames = local.workspace["enable_dns_hostnames"]
  enable_dns_support   = local.workspace["enable_dns_support"]

  # Configuración de subnets de base de datos
  create_database_subnet_group           = local.workspace["create_database_subnet_group"]
  create_database_subnet_route_table     = local.workspace["create_database_subnet_route_table"]
  create_database_nat_gateway_route      = local.workspace["create_database_nat_gateway_route"]

  # Tags para las subnets
  public_subnet_tags   = local.workspace["public_subnet_tags"]
  private_subnet_tags  = local.workspace["private_subnet_tags"]
  database_subnet_tags = local.workspace["database_subnet_tags"]

  # Sufijos personalizados para identificar mejor las subnets
  public_subnet_suffix   = local.workspace["public_subnet_suffix"]
  private_subnet_suffix  = local.workspace["private_subnet_suffix"]
  database_subnet_suffix = local.workspace["database_subnet_suffix"]

  # Tags generales
  tags = local.workspace["tags"]
}
