################################################################################
# VPC Endpoints Outputs
################################################################################

output "endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = module.vpc_endpoints.endpoints
}

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = module.vpc_endpoints.security_group_arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.vpc_endpoints.security_group_id
}

# Individual endpoint outputs for easier reference
output "s3_endpoint_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["s3"].id, null)
}

output "ecr_api_endpoint_id" {
  description = "The ID of the ECR API VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["ecr_api"].id, null)
}

output "ecr_dkr_endpoint_id" {
  description = "The ID of the ECR DKR VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["ecr_dkr"].id, null)
}

output "secretsmanager_endpoint_id" {
  description = "The ID of the Secrets Manager VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["secretsmanager"].id, null)
}

output "logs_endpoint_id" {
  description = "The ID of the CloudWatch Logs VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["logs"].id, null)
}

output "monitoring_endpoint_id" {
  description = "The ID of the CloudWatch Monitoring VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["monitoring"].id, null)
}

output "ecs_endpoint_id" {
  description = "The ID of the ECS VPC endpoint"
  value       = try(module.vpc_endpoints.endpoints["ecs"].id, null)
}
