################################################################################
# CodePipeline Outputs
################################################################################





# GitHub Connection
output "github_connection_arn" {
  description = "ARN of the GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.github.arn
}

output "github_connection_status" {
  description = "Status of the GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.github.connection_status
}
