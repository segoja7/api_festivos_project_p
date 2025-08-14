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

output "codepipeline_role_id" {
  description = "codepipeline_role_id"
  value       = aws_iam_role.codepipeline_role.id
}

output "codebuild_role_id" {
  description = "codepipeline_role_id"
  value       = aws_iam_role.codebuild_role.id
}