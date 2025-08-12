################################################################################
# RDS Security Group Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración básica del Security Group
      name        = "rds-postgres-sg"
      description = "Security group for RDS PostgreSQL - allows access only from EKS nodes"
      
      # Reglas de ingreso con referencia al security group de EKS
      ingress_with_source_security_group_id = [
        {
          rule                     = "postgresql-tcp"
          description              = "PostgreSQL access from EKS nodes"
          source_security_group_id = var.eks_node_security_group_id
        }
      ]
      
      # Reglas de egreso - Permitir todo el tráfico saliente (necesario para updates, etc.)
      egress_rules = ["all-all"]
      
      # Configuración adicional
      use_name_prefix = true  # Permite actualizar el nombre después de la creación inicial
      
      # Tags específicos
      tags = {
        Name        = "rds-postgres-security-group"
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Database"
        Purpose     = "RDS PostgreSQL Security"
        Service     = "PostgreSQL"
        AccessFrom  = "EKS-Nodes-Only"
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
