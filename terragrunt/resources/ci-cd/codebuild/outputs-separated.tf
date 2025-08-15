################################################################################
# CodePipeline Outputs
################################################################################

# CodeBuild Projects
output "api_build_project_name" {
  description = "Name of the CodeBuild API build project"
  value       = aws_codebuild_project.api_build_project.name
}

output "frontend_build_project_name" {
  description = "Name of the CodeBuild Frontend build project"
  value       = aws_codebuild_project.frontend_build_project.name
}

output "db_bootstrap_project_name" {
  description = "Name of the CodeBuild DB bootstrap project"
  value       = aws_codebuild_project.db_bootstrap_project.name
}

output "deploy_project_name" {
  description = "Name of the CodeBuild deploy project"
  value       = aws_codebuild_project.deploy_project.name
}

output "api_build_project_arn" {
  description = "ARN of the CodeBuild API build project"
  value       = aws_codebuild_project.api_build_project.arn
}

output "frontend_build_project_arn" {
  description = "ARN of the CodeBuild Frontend build project"
  value       = aws_codebuild_project.frontend_build_project.arn
}

output "db_bootstrap_project_arn" {
  description = "ARN of the CodeBuild DB bootstrap project"
  value       = aws_codebuild_project.db_bootstrap_project.arn
}

output "deploy_project_arn" {
  description = "ARN of the CodeBuild deploy project"
  value       = aws_codebuild_project.deploy_project.arn
}

# CloudWatch Logs
output "cloudwatch_logs_group_name" {
  description = "Name of the CloudWatch Logs group for CodeBuild"
  value       = aws_cloudwatch_log_group.codebuild_logs.name
}

output "cloudwatch_logs_group_arn" {
  description = "ARN of the CloudWatch Logs group for CodeBuild"
  value       = aws_cloudwatch_log_group.codebuild_logs.arn
}
