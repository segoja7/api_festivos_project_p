################################################################################
# CodePipeline Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      github_connection_name = "arq-avanzada-github-connection"

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