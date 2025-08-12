################################################################################
# RDS Security Group Outputs
################################################################################

# Información básica del Security Group
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = module.security_group.security_group_arn
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.security_group.security_group_name
}

output "security_group_description" {
  description = "The description of the security group"
  value       = module.security_group.security_group_description
}

# Información de red
output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.security_group.security_group_vpc_id
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = module.security_group.security_group_owner_id
}

# Output útil para usar en RDS
output "rds_security_group_ids" {
  description = "List containing the security group ID for use in RDS configuration"
  value       = [module.security_group.security_group_id]
}
