################################################################################
# RDS PostgreSQL Outputs
################################################################################

# Información básica de la instancia
output "db_instance_id" {
  description = "The RDS instance identifier"
  value       = module.rds.db_instance_identifier
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.db_instance_address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_port" {
  description = "The database port"
  value       = module.rds.db_instance_port
}

# Información de la base de datos
output "db_instance_name" {
  description = "The database name"
  value       = module.rds.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.rds.db_instance_username
  sensitive   = true
}

# Secrets Manager (para la contraseña)
output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.rds.db_instance_master_user_secret_arn
}

# Información de red
output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.rds.db_instance_availability_zone
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.rds.db_instance_hosted_zone_id
}

# Estado y configuración
output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.rds.db_instance_status
}

output "db_instance_engine" {
  description = "The database engine"
  value       = module.rds.db_instance_engine
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = module.rds.db_instance_engine_version_actual
}

# Grupos de recursos
output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.rds.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.rds.db_parameter_group_arn
}

# Información útil para aplicaciones
output "connection_string" {
  description = "Connection string for applications (without password)"
  value       = "postgresql://${module.rds.db_instance_username}@${module.rds.db_instance_endpoint}/${module.rds.db_instance_name}"
  sensitive   = true
}

output "jdbc_connection_string" {
  description = "JDBC connection string for Java applications"
  value       = "jdbc:postgresql://${module.rds.db_instance_endpoint}:${module.rds.db_instance_port}/${module.rds.db_instance_name}"
}

# Para uso en aplicaciones que necesiten los detalles por separado
output "database_config" {
  description = "Database configuration object for applications"
  value = {
    host     = module.rds.db_instance_address
    port     = module.rds.db_instance_port
    database = module.rds.db_instance_name
    username = module.rds.db_instance_username
    secret_arn = module.rds.db_instance_master_user_secret_arn
  }
  sensitive = true
}
