################################################################################
# VPC Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración básica de la VPC
      vpc_name = "arquitectura-avanzada-vpc"
      vpc_cidr = "10.0.0.0/16"
      
      # Zonas de disponibilidad
      availability_zones = ["us-east-1a", "us-east-1b"]
      
      # Subnets públicas para el Application Load Balancer
      public_subnets = [
        "10.0.1.0/24",   # us-east-1a
        "10.0.2.0/24"    # us-east-1b
      ]
      
      # Subnets privadas para aplicaciones (EKS cluster)
      private_subnets = [
        "10.0.10.0/24",  # us-east-1a - apps
        "10.0.20.0/24"   # us-east-1b - apps
      ]
      
      # Subnets privadas para base de datos (RDS PostgreSQL)
      database_subnets = [
        "10.0.100.0/24", # us-east-1a - database
        "10.0.200.0/24"  # us-east-1b - database
      ]
      
      # Configuración de NAT Gateway - Un solo NAT para reducir costos
      enable_nat_gateway = true
      single_nat_gateway = true
      enable_vpn_gateway = false
      
      # Configuración de DNS
      enable_dns_hostnames = true
      enable_dns_support   = true
      
      # Configuración de subnets de base de datos
      create_database_subnet_group           = true
      create_database_subnet_route_table     = true
      create_database_nat_gateway_route      = true
      
      # Tags para las subnets públicas (para el ALB)
      public_subnet_tags = {
        "kubernetes.io/role/elb" = "1"
        Type                     = "public"
        Tier                     = "web"
      }
      
      # Tags para las subnets privadas (para EKS)
      private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = "1"
        Type                              = "private"
        Tier                              = "app"
      }
      
      # Tags para las subnets de base de datos
      database_subnet_tags = {
        Type = "private"
        Tier = "database"
      }
      
      # Sufijos personalizados para identificar mejor las subnets
      public_subnet_suffix   = "public"
      private_subnet_suffix  = "apps"
      database_subnet_suffix = "db"
      
      # VPC Endpoints para acceso privado a servicios AWS (ECR)
      # Habilitar VPC Endpoints
      enable_vpc_endpoints = true
      
      # Endpoints específicos para ECR
      vpc_endpoints = {
        # ECR API Endpoint
        ecr_api = {
          service             = "ecr.api"
          vpc_endpoint_type   = "Interface"
          subnet_ids          = []  # Se usarán las subnets privadas
          security_group_ids  = []  # Se creará automáticamente
          private_dns_enabled = true
          policy              = null
          tags = {
            Name = "arquitectura-avanzada-ecr-api-endpoint"
            Type = "ECR API VPC Endpoint"
          }
        }
        
        # ECR Docker Endpoint
        ecr_dkr = {
          service             = "ecr.dkr"
          vpc_endpoint_type   = "Interface"
          subnet_ids          = []  # Se usarán las subnets privadas
          security_group_ids  = []  # Se creará automáticamente
          private_dns_enabled = true
          policy              = null
          tags = {
            Name = "arquitectura-avanzada-ecr-dkr-endpoint"
            Type = "ECR Docker VPC Endpoint"
          }
        }
        
        # S3 Gateway Endpoint
        s3 = {
          service           = "s3"
          vpc_endpoint_type = "Gateway"
          route_table_ids   = []  # Se usarán las route tables privadas
          policy            = null
          tags = {
            Name = "arquitectura-avanzada-s3-gateway-endpoint"
            Type = "S3 Gateway VPC Endpoint"
          }
        }
      }
      
      # Tags generales
      tags = {
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Network"
      }
    }
    
    dev = {
      # Configuraciones específicas para desarrollo
    }
    
    prod = {
      # Configuraciones específicas para producción
    }
  }
  
  # Lógica para seleccionar el ambiente (solo default por ahora)
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}
