################################################################################
# Secrets Manager Parameters - Terragrunt Native Approach
################################################################################

locals {
  # Define all secrets to be managed in this map.
  # The key of the map (e.g., "jwt", "dockerhub") is a logical name used for iteration.

  # The following locals are kept for compatibility but are now deprecated
  # in favor of the 'secrets' map structure.
  env = {
    default = {
      secrets = {
        jwt = {
          secret_name                = "arquitectura-avanzada/jwt-secrets"
          secret_description         = "JWT and application secrets for arquitectura avanzada project"
          recovery_window_in_days    = 30
          kms_key_id                 = null  # Uses default AWS managed key
          create_policy              = false
          block_public_policy        = true
          policy_statements          = {}
          create_random_password     = false
          secret_string = jsonencode({
            jwt_secret = "5367566B59703373367639792F423F4528482B4D6251655468576D5A71347437"
          })
          secret_binary              = null
          ignore_secret_changes      = false
          version_stages             = null
          enable_rotation            = false
          rotation_lambda_arn        = ""
          rotation_rules             = {}
          replica                    = {}
          force_overwrite_replica_secret = null
          tags = {
            Terraform   = "true"
            Environment = "dev"
            Project     = "arquitectura-avanzada-udea"
            SecretType  = "JWT"
          }
        },
        dockerhub = {
          secret_name                = "dockerhub-credentials"
          secret_description         = "Credentials for Docker Hub to avoid rate limiting."
          recovery_window_in_days    = 30
          kms_key_id                 = null
          create_policy              = false
          block_public_policy        = true
          policy_statements          = {}
          create_random_password     = false
          # =================================================================
          # IMPORTANTE: Reemplaza estos con tus credenciales reales de Docker Hub
          # =================================================================
          secret_string = jsonencode({
            username = "your-dockerhub-username"
            password = "your-dockerhub-password-or-token"
          })
          secret_binary              = null
          ignore_secret_changes      = false
          version_stages             = null
          enable_rotation            = false
          rotation_lambda_arn        = ""
          rotation_rules             = {}
          replica                    = {}
          force_overwrite_replica_secret = null
          tags = {
            Terraform   = "true"
            Environment = "dev"
            Project     = "arquitectura-avanzada-udea"
            SecretType  = "DockerHub Credentials"
          }
        }
      }      
    }
    dev = {}
    prod = {}
  }
  # Lógica para seleccionar el ambiente
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}