################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "ARN de la VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "CIDR block de la VPC"
  value       = module.vpc.vpc_cidr_block
}

################################################################################
# Subnets Outputs
################################################################################

# Subnets Públicas (para ALB)
output "public_subnets" {
  description = "Lista de IDs de las subnets públicas"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "Lista de CIDR blocks de las subnets públicas"
  value       = module.vpc.public_subnets_cidr_blocks
}

# Subnets Privadas (para EKS)
output "private_subnets" {
  description = "Lista de IDs de las subnets privadas (apps)"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "Lista de CIDR blocks de las subnets privadas (apps)"
  value       = module.vpc.private_subnets_cidr_blocks
}

# Subnets de Base de Datos
output "database_subnets" {
  description = "Lista de IDs de las subnets de base de datos"
  value       = module.vpc.database_subnets
}

output "database_subnets_cidr_blocks" {
  description = "Lista de CIDR blocks de las subnets de base de datos"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "database_subnet_group" {
  description = "ID del grupo de subnets de base de datos"
  value       = module.vpc.database_subnet_group
}

output "database_subnet_group_name" {
  description = "Nombre del grupo de subnets de base de datos"
  value       = module.vpc.database_subnet_group_name
}

################################################################################
# Gateway Outputs
################################################################################

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "Lista de IDs de los NAT Gateways"
  value       = module.vpc.natgw_ids
}

output "nat_public_ips" {
  description = "Lista de IPs públicas de los NAT Gateways"
  value       = module.vpc.nat_public_ips
}

################################################################################
# Route Tables Outputs
################################################################################

output "public_route_table_ids" {
  description = "Lista de IDs de las tablas de rutas públicas"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Lista de IDs de las tablas de rutas privadas"
  value       = module.vpc.private_route_table_ids
}

output "database_route_table_ids" {
  description = "Lista de IDs de las tablas de rutas de base de datos"
  value       = module.vpc.database_route_table_ids
}

################################################################################
# Availability Zones Output
################################################################################

output "azs" {
  description = "Lista de zonas de disponibilidad utilizadas"
  value       = module.vpc.azs
}

################################################################################
# Outputs útiles para EKS
################################################################################

output "all_subnets" {
  description = "Lista de todas las subnets (públicas y privadas) para EKS"
  value       = concat(module.vpc.public_subnets, module.vpc.private_subnets)
}

output "eks_subnets" {
  description = "Subnets específicas para EKS (privadas para nodos)"
  value       = module.vpc.private_subnets
}

output "alb_subnets" {
  description = "Subnets específicas para ALB (públicas)"
  value       = module.vpc.public_subnets
}
