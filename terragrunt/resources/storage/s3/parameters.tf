################################################################################
# Secrets Manager Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración de artefactos S3
      artifacts_bucket_name = "arquitectura-avanzada-pipeline-artifacts"
      artifacts_bucket_force_destroy = true
      artifacts_encryption_key_id = "alias/aws/s3"
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
    },
    dev = {
      # Configuraciones específicas para desarrollo
    },
    prod = {
      # Configuraciones específicas para producción
    }
  }

  # Lógica para seleccionar el ambiente
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}