################################################################################
# Secrets Manager Outputs
################################################################################

output "secrets" {
  description = "A map of all created secrets, keyed by their logical name."
  value = {
    for k, secret in module.secrets_manager : k => {
      arn        = secret.secret_arn
      id         = secret.secret_id
      name       = secret.secret_name
      version_id = secret.secret_version_id
    }
  }
}

# Note: secret_string and secret_binary outputs are marked as sensitive
# They won't be displayed in terraform output but can be referenced by other modules
output "secret_strings" {
  description = "The secret strings for all secrets (sensitive)"
  value       = { for k, secret in module.secrets_manager : k => secret.secret_string }
  sensitive   = true
}