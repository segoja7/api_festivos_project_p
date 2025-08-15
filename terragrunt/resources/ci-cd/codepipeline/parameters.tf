################################################################################
# CodePipeline Parameters - Terragrunt Native Approach
################################################################################
data "aws_caller_identity" "account" {}

# data "aws_region" "current" {}

locals {
  env = {
    default = {
      # Configuración básica del pipeline

      pipeline_name = "arquitectura-avanzada-pipeline"
      # Configuración de Source (GitHub)
      github_owner = "segoja7"
      github_repo = "api_festivos_project_p"
#      github_branch = "master"
      github_branch = "new_code_app"
      github_connection_name = "arq-avanzada-github-connection"
      
      # Configuración de Build (CodeBuild)
      codebuild_project_name = "arquitectura-avanzada-build"

      codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
      codebuild_image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
      codebuild_type = "LINUX_CONTAINER"
      codebuild_privileged_mode = true
      
      # Configuración de Deploy (EKS)
      deploy_stage_name = "Deploy"
      deploy_action_name = "DeployToEKS"
      

      
      # Variables de entorno para CodeBuild (convertido a mapa)
      environment_variables = {
        AWS_DEFAULT_REGION = {
          name  = "AWS_DEFAULT_REGION"
          value = data.aws_region.current.name
          type  = "PLAINTEXT"
        },
        AWS_ACCOUNT_ID = {
          name  = "AWS_ACCOUNT_ID"
          value = data.aws_caller_identity.account.account_id
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
      }
      
      # Configuración de buildspec
      
      
      # Configuración de notificaciones (opcional)
      enable_notifications = false
      notification_events = [
        "codepipeline-pipeline-pipeline-execution-failed",
        "codepipeline-pipeline-pipeline-execution-succeeded"
      ]
      
      # Configuración de logs
      cloudwatch_logs_group_name = "/aws/codebuild/arquitectura-avanzada-build"
      cloudwatch_logs_retention_days = 14
      
      # Configuración de timeout
      build_timeout = 60
      queued_timeout = 480
      
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