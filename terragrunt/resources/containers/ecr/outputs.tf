################################################################################
# ECR Outputs
################################################################################

# Información básica del repositorio
output "repository_name" {
  description = "Name of the repository"
  value       = module.ecr.repository_name
}

output "repository_arn" {
  description = "Full ARN of the repository"
  value       = module.ecr.repository_arn
}

output "repository_url" {
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)"
  value       = module.ecr.repository_url
}

output "repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr.repository_registry_id
}

# Outputs útiles para EKS y CI/CD
output "repository_uri" {
  description = "The URI of the repository (same as repository_url)"
  value       = module.ecr.repository_url
}

output "registry_url" {
  description = "The registry URL (aws_account_id.dkr.ecr.region.amazonaws.com)"
  value       = split("/", module.ecr.repository_url)[0]
}
