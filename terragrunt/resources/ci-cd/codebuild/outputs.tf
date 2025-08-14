################################################################################
# CodePipeline Outputs
################################################################################

# CodeBuild Projects
output "build_project_name" {
  description = "Name of the CodeBuild build project"
  value       = aws_codebuild_project.build_project.name
}

output "db_bootstrap_project_name" {
  description = "Name of the CodeBuild build project"
  value       = aws_codebuild_project.db_bootstrap_project.name
}

output "deploy_project_name" {
  description = "Name of the CodeBuild build project"
  value       = aws_codebuild_project.deploy_project.name
}

output "build_project_arn" {
  description = "ARN of the CodeBuild build project"
  value       = aws_codebuild_project.build_project.arn
}

output "db_bootstrap_project_arn" {
  description = "ARN of the CodeBuild db_bootstrap_project project"
  value       = aws_codebuild_project.db_bootstrap_project.arn
}

output "deploy_project_arn" {
  description = "ARN of the CodeBuild deploy_project project"
  value       = aws_codebuild_project.deploy_project.arn
}

# # S3 Artifacts Bucket
# output "artifacts_bucket_name" {
#   description = "Name of the S3 bucket for pipeline artifacts"
#   value       = aws_s3_bucket.codepipeline_artifacts.bucket
# }
#
# output "artifacts_bucket_arn" {
#   description = "ARN of the S3 bucket for pipeline artifacts"
#   value       = aws_s3_bucket.codepipeline_artifacts.arn
# }



# CloudWatch Logs
output "cloudwatch_logs_group_name" {
  description = "Name of the CloudWatch Logs group for CodeBuild"
  value       = aws_cloudwatch_log_group.codebuild_logs.name
}

output "cloudwatch_logs_group_arn" {
  description = "ARN of the CloudWatch Logs group for CodeBuild"
  value       = aws_cloudwatch_log_group.codebuild_logs.arn
}
