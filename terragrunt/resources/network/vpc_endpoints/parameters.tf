################################################################################
# VPC Endpoints Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración básica
      vpc_id = var.vpc_id
      
      # Configuración de Security Group
      create_security_group      = true
      security_group_name_prefix = "vpc-endpoints-"
      security_group_description = "VPC endpoint security group"
      security_group_rules = {
        ingress_https = {
          description = "HTTPS from VPC"
          cidr_blocks = [var.vpc_cidr_block]
        }
      }
      
      # Configuración de endpoints procesados
      endpoints = {
        # S3 Gateway Endpoint for ECR image layers
        s3 = {
          service         = "s3"
          service_type    = "Gateway"
          route_table_ids = flatten([
            var.private_route_table_ids,
            var.public_route_table_ids
          ])
          tags = { Name = "s3-vpc-endpoint" }
        }
        
        # ECR API Interface Endpoint
        ecr_api = {
          service             = "ecr.api"
          service_type        = "Interface"
          private_dns_enabled = true
          subnet_ids          = var.private_subnets
          tags                = { Name = "ecr-api-vpc-endpoint" }
        }
        
        # ECR DKR Interface Endpoint
        ecr_dkr = {
          service             = "ecr.dkr"
          service_type        = "Interface"
          private_dns_enabled = true
          subnet_ids          = var.private_subnets
          tags                = { Name = "ecr-dkr-vpc-endpoint" }
        }
        
        # ECS Interface Endpoint (for EKS integration)
        ecs = {
          service             = "ecs"
          service_type        = "Interface"
          private_dns_enabled = true
          subnet_ids          = var.private_subnets
          tags                = { Name = "ecs-vpc-endpoint" }
        }
        
        # CloudWatch Logs Interface Endpoint
        logs = {
          service             = "logs"
          service_type        = "Interface"
          private_dns_enabled = true
          subnet_ids          = var.private_subnets
          tags                = { Name = "logs-vpc-endpoint" }
        }
        
        # CloudWatch Monitoring Interface Endpoint
        monitoring = {
          service             = "monitoring"
          service_type        = "Interface"
          private_dns_enabled = true
          subnet_ids          = var.private_subnets
          tags                = { Name = "monitoring-vpc-endpoint" }
        }
        
        # Secrets Manager Interface Endpoint (for External Secrets)
        secretsmanager = {
          service             = "secretsmanager"
          service_type        = "Interface"
          private_dns_enabled = true
          subnet_ids          = var.private_subnets
          tags                = { Name = "secretsmanager-vpc-endpoint" }
        }
      }
      
      # Tags específicos
      tags = {
        Name        = "vpc-endpoints"
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Network"
        Service     = "VPC-Endpoints"
        Purpose     = "Private AWS Service Access"
        Component   = "vpc-endpoints"
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
