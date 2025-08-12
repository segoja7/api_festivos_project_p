################################################################################
# CodePipeline Outputs
################################################################################

# Pipeline Information
output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.pipeline.name
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.pipeline.arn
}

# GitHub Connection
output "github_connection_arn" {
  description = "ARN of the GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.github.arn
}

output "github_connection_status" {
  description = "Status of the GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.github.connection_status
}

# CodeBuild Projects
output "build_project_name" {
  description = "Name of the CodeBuild build project"
  value       = aws_codebuild_project.build_project.name
}

output "build_project_arn" {
  description = "ARN of the CodeBuild build project"
  value       = aws_codebuild_project.build_project.arn
}

# S3 Artifacts Bucket
output "artifacts_bucket_name" {
  description = "Name of the S3 bucket for pipeline artifacts"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for pipeline artifacts"
  value       = aws_s3_bucket.codepipeline_artifacts.arn
}

# IAM Roles
output "codepipeline_role_arn" {
  description = "ARN of the CodePipeline service role"
  value       = aws_iam_role.codepipeline_role.arn
}

output "codepipeline_role_name" {
  description = "Name of the CodePipeline service role"
  value       = aws_iam_role.codepipeline_role.name
}

output "codebuild_role_arn" {
  description = "ARN of the CodeBuild service role"
  value       = aws_iam_role.codebuild_role.arn
}

output "codebuild_role_name" {
  description = "Name of the CodeBuild service role"
  value       = aws_iam_role.codebuild_role.name
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
