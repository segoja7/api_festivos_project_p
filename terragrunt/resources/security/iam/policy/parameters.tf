################################################################################
# Secrets Manager Parameters - Terragrunt Native Approach
################################################################################

locals {
  # The following locals are kept for compatibility but are now deprecated
  # in favor of the 'secrets' map structure.
  env = {
    default = {
      pipeline_name       = "arquitectura-avanzada-pipeline"
      pipeline_role_name  = "arquitectura-avanzada-codepipeline-role"
      codebuild_role_name = "arquitectura-avanzada-codebuild-role"
    }
    dev  = {}
    prod = {}
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}