# Random string for unique resource names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

################################################################################
# S3 Bucket para artifacts del pipeline
################################################################################

resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket        = "${local.workspace.artifacts_bucket_name}-${random_string.bucket_suffix.result}"
  force_destroy = local.workspace.artifacts_bucket_force_destroy

  tags = merge(local.workspace.tags, {
    Name = "${local.workspace.artifacts_bucket_name}-${random_string.bucket_suffix.result}"
    Type = "Pipeline Artifacts"
  })
}

resource "aws_s3_bucket_versioning" "codepipeline_artifacts" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_artifacts" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
      kms_master_key_id = local.workspace.artifacts_encryption_key_id != "alias/aws/s3" ? local.workspace.artifacts_encryption_key_id : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "codepipeline_artifacts" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
