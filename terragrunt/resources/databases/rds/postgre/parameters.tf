################################################################################
# RDS PostgreSQL Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración básica de RDS
      identifier = "arquitectura-avanzada-postgres"
      
      # Motor de base de datos PostgreSQL 17
      engine         = "postgres"
      engine_version = "17.4"  # PostgreSQL 17 más reciente
      family         = "postgres17"
      major_engine_version = "17"
      
      # Clase de instancia (optimizada para desarrollo)
      instance_class = "db.t3.micro"  # Elegible para free tier
      
      # Almacenamiento
      allocated_storage     = 20    # GB mínimo
      max_allocated_storage = 100   # Autoscaling hasta 100GB
      storage_type         = "gp3"  # Última generación SSD
      storage_encrypted    = true   # Siempre encriptado
      
      # Base de datos
      db_name  = "arquitectura_db"
      username = "postgres_admin"
      port     = "5432"
      
      # Gestión de contraseñas con AWS Secrets Manager
      manage_master_user_password = true  # Usar AWS Secrets Manager
      password = null  # No especificar contraseña manual
      
      # Configuración de red (Single AZ para desarrollo)
      multi_az               = false  # Single AZ para reducir costos
      publicly_accessible    = false  # Siempre privado
      
      # Configuración de subnet group
      create_db_subnet_group = true
      
      # Configuración de parámetros y opciones
      create_db_parameter_group = true
      create_db_option_group    = false  # PostgreSQL no usa option groups
      
      # Configuración para manejar parámetros estáticos
      apply_immediately = false  # No aplicar inmediatamente cambios que requieren reinicio
      
      # Backups y mantenimiento
      backup_retention_period = 7      # 7 días para desarrollo
      backup_window          = "03:00-04:00"  # UTC
      maintenance_window     = "sun:04:00-sun:05:00"  # UTC
      
      # Eliminación y snapshots
      deletion_protection   = false  # Permitir eliminación en desarrollo
      skip_final_snapshot  = true   # No crear snapshot final en desarrollo
      delete_automated_backups = true
      
      # Monitoreo
      monitoring_interval = 0  # Deshabilitado para desarrollo (reduce costos)
      create_monitoring_role = false
      
      # Performance Insights (deshabilitado para desarrollo)
      performance_insights_enabled = false
      
      # Logs de CloudWatch (solo errores para desarrollo)
      enabled_cloudwatch_logs_exports = ["postgresql"]
      create_cloudwatch_log_group = true
      cloudwatch_log_group_retention_in_days = 7
      
      
      # Parámetros específicos de PostgreSQL 17
      # Solo parámetros dinámicos que no requieren reinicio
      parameters = [
        {
          name  = "log_min_duration_statement"
          value = "1000"  # Log consultas que tomen más de 1 segundo
        },
        {
          name  = "log_connections"
          value = "1"  # Log conexiones
        },
        {
          name  = "log_disconnections"
          value = "1"  # Log desconexiones
        }
      ]
      
      # Tags específicos
      tags = {
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Database"
        Engine      = "PostgreSQL"
        Version     = "17"
        Purpose     = "Application Database"
      }
      
      # Tags adicionales para la instancia
      db_instance_tags = {
        Name = "arquitectura-avanzada-postgres-dev"
        Type = "Primary Database"
      }
      
      # Tags para el subnet group
      db_subnet_group_tags = {
        Name = "arquitectura-avanzada-postgres-subnet-group"
        Type = "Database Subnet Group"
      }
      
      # Tags para el parameter group
      db_parameter_group_tags = {
        Name = "arquitectura-avanzada-postgres-params"
        Type = "Database Parameter Group"
      }
    }
    
    dev = {
      # Configuraciones específicas para desarrollo
    }
    
    prod = {
      # Configuraciones específicas para producción
    }
  }
  
  # Lógica para seleccionar el ambiente
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}
