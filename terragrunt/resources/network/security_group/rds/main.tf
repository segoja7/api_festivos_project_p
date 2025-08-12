################################################################################
# RDS Security Group Module
################################################################################

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  # Configuración básica
  name        = local.workspace["name"]
  description = local.workspace["description"]
  vpc_id      = var.vpc_id

  # Reglas de ingreso - PostgreSQL solo desde security group de EKS nodes
  ingress_with_source_security_group_id = local.workspace["ingress_with_source_security_group_id"]

  # Reglas de egreso - Permitir todo el tráfico saliente
  egress_rules = local.workspace["egress_rules"]

  # Configuración adicional
  use_name_prefix = local.workspace["use_name_prefix"]

  # Tags
  tags = local.workspace["tags"]
}
