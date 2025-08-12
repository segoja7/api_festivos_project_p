################################################################################
# RDS PostgreSQL Module
################################################################################

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  # Configuración básica
  identifier = local.workspace["identifier"]
  
  # Motor de base de datos
  engine         = local.workspace["engine"]
  engine_version = local.workspace["engine_version"]
  family         = local.workspace["family"]
  major_engine_version = local.workspace["major_engine_version"]
  
  # Clase de instancia
  instance_class = local.workspace["instance_class"]
  
  # Almacenamiento
  allocated_storage     = local.workspace["allocated_storage"]
  max_allocated_storage = local.workspace["max_allocated_storage"]
  storage_type         = local.workspace["storage_type"]
  storage_encrypted    = local.workspace["storage_encrypted"]
  
  # Base de datos
  db_name  = local.workspace["db_name"]
  username = local.workspace["username"]
  password = local.workspace["password"]
  port     = local.workspace["port"]
  
  # Gestión de contraseñas con AWS Secrets Manager
  manage_master_user_password = local.workspace["manage_master_user_password"]
  
  # Configuración de red
  multi_az               = local.workspace["multi_az"]
  publicly_accessible    = local.workspace["publicly_accessible"]
  vpc_security_group_ids = var.vpc_security_group_ids
  
  # Subnet group - usar el creado por el módulo VPC
  create_db_subnet_group = false  # No crear, usar el existente
  db_subnet_group_name   = var.database_subnet_group_name
  
  # Configuración de parámetros y opciones
  create_db_parameter_group = local.workspace["create_db_parameter_group"]
  create_db_option_group    = local.workspace["create_db_option_group"]
  apply_immediately        = local.workspace["apply_immediately"]
  
  # Backups y mantenimiento
  backup_retention_period = local.workspace["backup_retention_period"]
  backup_window          = local.workspace["backup_window"]
  maintenance_window     = local.workspace["maintenance_window"]
  
  # Eliminación y snapshots
  deletion_protection      = local.workspace["deletion_protection"]
  skip_final_snapshot     = local.workspace["skip_final_snapshot"]
  delete_automated_backups = local.workspace["delete_automated_backups"]
  
  # Monitoreo
  monitoring_interval    = local.workspace["monitoring_interval"]
  create_monitoring_role = local.workspace["create_monitoring_role"]
  
  # Performance Insights
  performance_insights_enabled = local.workspace["performance_insights_enabled"]
  
  # Logs de CloudWatch
  enabled_cloudwatch_logs_exports        = local.workspace["enabled_cloudwatch_logs_exports"]
  create_cloudwatch_log_group           = local.workspace["create_cloudwatch_log_group"]
  cloudwatch_log_group_retention_in_days = local.workspace["cloudwatch_log_group_retention_in_days"]

  
  # Parámetros específicos de PostgreSQL
  parameters = local.workspace["parameters"]
  
  # Tags
  tags                    = local.workspace["tags"]
  db_instance_tags        = local.workspace["db_instance_tags"]
  db_subnet_group_tags    = local.workspace["db_subnet_group_tags"]
  db_parameter_group_tags = local.workspace["db_parameter_group_tags"]
}
