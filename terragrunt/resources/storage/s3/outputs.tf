
output "s3_bucket_arn" {
  description = "The arn s3 "
  value       = aws_s3_bucket.codepipeline_artifacts.arn
}

output "s3_bucket" {
  value = aws_s3_bucket.codepipeline_artifacts.bucket
}