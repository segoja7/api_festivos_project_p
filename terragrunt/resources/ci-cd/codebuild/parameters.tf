################################################################################
# CodePipeline Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {

      pipeline_name = "arquitectura-avanzada-pipeline"

      
      # Configuración de Build (CodeBuild)
      codebuild_project_name = "arquitectura-avanzada-build"

      codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
      codebuild_image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
      codebuild_type = "LINUX_CONTAINER"
      codebuild_privileged_mode = true
      

      

      
      # Variables de entorno para CodeBuild (convertido a mapa)
      environment_variables = {
        AWS_DEFAULT_REGION = {
          name  = "AWS_DEFAULT_REGION"
          value = data.aws_region.current.name
          type  = "PLAINTEXT"
        },
        AWS_ACCOUNT_ID = {
          name  = "AWS_ACCOUNT_ID"
          value = data.aws_caller_identity.current.id
          type  = "PLAINTEXT"
        },
        IMAGE_REPO_NAME = {
          name  = "IMAGE_REPO_NAME"
          value = var.ecr_repository_name
          type  = "PLAINTEXT"
        },
        IMAGE_TAG = {
          name  = "IMAGE_TAG"
          value = "latest"
          type  = "PLAINTEXT"
        },
        EKS_CLUSTER_NAME = {
          name  = "EKS_CLUSTER_NAME"
          value = var.eks_cluster_name
          type  = "PLAINTEXT"
        },
        JWT_SECRET_ARN = {
          name  = "JWT_SECRET_ARN"
          value = var.jwt_secret_arn
          type  = "PLAINTEXT"
        }
        DOCKERHUB_SECRET_ARN = {
           name  = "DOCKERHUB_SECRET_ARN"
           value = var.dockerhub_secret_arn
           type  = "PLAINTEXT"
        }
        RDS_SECRET_ARN = {
          name  = "RDS_SECRET_ARN"
          value = var.rds_secret_arn
          type  = "PLAINTEXT"
        }
        ECR_REPOSITORY_URI = {
          name  = "ECR_REPOSITORY_URI"
          value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.ecr_repository_name}"
          type  = "PLAINTEXT"
        }
        PROJECT_NAME = {
          name  = "PROJECT_NAME"
          value = "arquitectura-avanzada"
          type  = "PLAINTEXT"
        }
        APP_NAME = {
          name  = "APP_NAME"
          value = "festivos"
          type  = "PLAINTEXT"
        }
        NAMESPACE = {
          name  = "NAMESPACE"
          value = "festivos-api"
          type  = "PLAINTEXT"
        }
        ENVIRONMENT = {
          name  = "ENVIRONMENT"
          value = "dev"
          type  = "PLAINTEXT"
        }
        DB_NAME = {
          name  = "DB_NAME"
          value = "festivos"
          type  = "PLAINTEXT"
        }
        DB_PORT = {
          name  = "DB_PORT"
          value = "5432"
          type  = "PLAINTEXT"
        }
        # Agregar después de DB_PORT:
        RDS_ENDPOINT = {
          name  = "RDS_ENDPOINT"
          value = var.rds_endpoint
          type  = "PLAINTEXT"
        }

      }
      
      # Configuración de buildspec
      
      


      
      # Configuración de logs
      cloudwatch_logs_group_name = "/aws/codebuild/arquitectura-avanzada-build"
      cloudwatch_logs_retention_days = 14
      

      
      # Tags específicos
      tags = {
        Name        = "arquitectura-avanzada-codepipeline"
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "CI/CD"
        Service     = "CodePipeline"
        Purpose     = "Continuous Integration and Deployment"
        Component   = "Pipeline"
      }
    }
    
    dev = {}
    prod = {}
  }
  
  # Lógica para seleccionar el ambiente
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}