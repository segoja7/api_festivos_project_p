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
          value = "us-east-1"
          type  = "PLAINTEXT"
        },
        AWS_ACCOUNT_ID = {
          name  = "AWS_ACCOUNT_ID"
          value = "476114125818"
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