
# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
################################################################################
# IAM Role para CodePipeline
################################################################################

resource "aws_iam_role" "codepipeline_role" {
  name = local.workspace["pipeline_role_name"]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = local.workspace.pipeline_role_name
    Type = "CodePipeline Service Role"
  }
}


################################################################################
# IAM Role para CodeBuild
################################################################################

resource "aws_iam_role" "codebuild_role" {
  name = local.workspace.codebuild_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = local.workspace.codebuild_role_name
    Type = "CodeBuild Service Role"
  }
}
