################################################################################
# ECR Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración básica del repositorio
      repository_name = "arquitectura-avanzada-app"
      repository_type = "private"  # private o public
      
      # Configuración de seguridad
      repository_image_tag_mutability = "MUTABLE"     # MUTABLE para desarrollo, IMMUTABLE para producción
      repository_image_scan_on_push   = true          # Escanear imágenes al hacer push
      repository_force_delete         = true          # Permitir eliminar repo con imágenes (solo desarrollo)
      
      # Configuración de encriptación
      repository_encryption_type = "AES256"  # AES256 o KMS
      
      # Política de ciclo de vida para gestionar imágenes
      repository_lifecycle_policy = jsonencode({
        rules = [
          {
            rulePriority = 1
            description  = "Keep last 10 production images"
            selection = {
              tagStatus     = "tagged"
              tagPrefixList = ["v", "prod"]
              countType     = "imageCountMoreThan"
              countNumber   = 10
            }
            action = {
              type = "expire"
            }
          },
          {
            rulePriority = 2
            description  = "Keep last 5 development images"
            selection = {
              tagStatus     = "tagged"
              tagPrefixList = ["dev", "staging"]
              countType     = "imageCountMoreThan"
              countNumber   = 5
            }
            action = {
              type = "expire"
            }
          },
          {
            rulePriority = 3
            description  = "Delete untagged images older than 1 day"
            selection = {
              tagStatus   = "untagged"
              countType   = "sinceImagePushed"
              countUnit   = "days"
              countNumber = 1
            }
            action = {
              type = "expire"
            }
          }
        ]
      })
      
      # Permisos de acceso al repositorio
      repository_read_write_access_arns = [
        "arn:aws:iam::476114125818:user/udea",
        "arn:aws:iam::476114125818:user/iamadmin_gnral"
      ]
      
      # Configuración de creación de recursos
      create_repository        = true
      create_lifecycle_policy  = true
      create_repository_policy = true
      attach_repository_policy = true
      
      # Tags específicos
      tags = {
        Name        = "arquitectura-avanzada-ecr"
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Container"
        Service     = "ECR"
        Purpose     = "Container Image Registry"
        Repository  = "Application Images"
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
