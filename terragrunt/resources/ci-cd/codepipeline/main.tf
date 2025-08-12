################################################################################
# CodePipeline Infrastructure
################################################################################

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

################################################################################
# GitHub Connection
################################################################################

resource "aws_codestarconnections_connection" "github" {
  name          = local.workspace.github_connection_name
  provider_type = "GitHub"
  
  tags = merge(local.workspace.tags, {
    Name = local.workspace.github_connection_name
    Type = "GitHub Connection"
  })
}

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

################################################################################
# CloudWatch Logs para CodeBuild
################################################################################

resource "aws_cloudwatch_log_group" "codebuild_logs" {
  name              = local.workspace.cloudwatch_logs_group_name
  retention_in_days = local.workspace.cloudwatch_logs_retention_days
  
  tags = merge(local.workspace.tags, {
    Name = local.workspace.cloudwatch_logs_group_name
    Type = "CodeBuild Logs"
  })
}

################################################################################
# IAM Role para CodePipeline
################################################################################

resource "aws_iam_role" "codepipeline_role" {
  name = local.workspace.pipeline_role_name

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
  
  tags = merge(local.workspace.tags, {
    Name = local.workspace.pipeline_role_name
    Type = "CodePipeline Service Role"
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${local.workspace.pipeline_role_name}-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.codepipeline_artifacts.arn,
          "${aws_s3_bucket.codepipeline_artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = [
          aws_codebuild_project.build_project.arn,
          aws_codebuild_project.db_bootstrap_project.arn,
          aws_codebuild_project.deploy_project.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection"
        ]
        Resource = aws_codestarconnections_connection.github.arn
      }
    ]
  })
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
  
  tags = merge(local.workspace.tags, {
    Name = local.workspace.codebuild_role_name
    Type = "CodeBuild Service Role"
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${local.workspace.codebuild_role_name}-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.codebuild_logs.arn}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.codepipeline_artifacts.arn,
          "${aws_s3_bucket.codepipeline_artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          var.rds_secret_arn,
          var.jwt_secret_arn,
          var.dockerhub_secret_arn
        ]
      }
    ]
  })
}

################################################################################
# CodeBuild Projects
################################################################################

resource "aws_codebuild_project" "build_project" {
  name          = local.workspace.codebuild_project_name
  description   = "Build project for ${local.workspace.pipeline_name}"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = local.workspace.codebuild_compute_type
    image                       = local.workspace.codebuild_image
    type                        = local.workspace.codebuild_type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = local.workspace.codebuild_privileged_mode

    dynamic "environment_variable" {
      for_each = local.workspace.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild_logs.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-fase1-build.yml"
  }

  tags = merge(local.workspace.tags, {
    Name = local.workspace.codebuild_project_name
    Type = "CodeBuild Project"
  })
}

resource "aws_codebuild_project" "db_bootstrap_project" {
  name          = "${local.workspace.codebuild_project_name}-db-bootstrap"
  description   = "Database bootstrap project for ${local.workspace.pipeline_name}"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = local.workspace.codebuild_compute_type
    image                       = local.workspace.codebuild_image
    type                        = local.workspace.codebuild_type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    dynamic "environment_variable" {
      for_each = merge(local.workspace.environment_variables, {
        RDS_SECRET_ARN = {
          name  = "RDS_SECRET_ARN"
          value = var.rds_secret_arn
          type  = "PLAINTEXT"
        }
      })
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild_logs.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-db-bootstrap.yml"
  }

  tags = merge(local.workspace.tags, {
    Name = "${local.workspace.codebuild_project_name}-db-bootstrap"
    Type = "CodeBuild Project"
  })
}

resource "aws_codebuild_project" "deploy_project" {
  name          = "${local.workspace.codebuild_project_name}-deploy"
  description   = "Deploy project for ${local.workspace.pipeline_name}"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = local.workspace.codebuild_compute_type
    image                       = local.workspace.codebuild_image
    type                        = local.workspace.codebuild_type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    dynamic "environment_variable" {
      for_each = local.workspace.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild_logs.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-deploy.yml"
  }

  tags = merge(local.workspace.tags, {
    Name = "${local.workspace.codebuild_project_name}-deploy"
    Type = "CodeBuild Project"
  })
}

################################################################################
# CodePipeline
################################################################################

resource "aws_codepipeline" "pipeline" {
  name     = local.workspace.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "${local.workspace.github_owner}/${local.workspace.github_repo}"
        BranchName       = local.workspace.github_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

  stage {
    name = "DatabaseBootstrap"

    action {
      name            = "BootstrapDB"
      category        = "Build" # Se usa la categoría Build para ejecutar scripts
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.db_bootstrap_project.name
      }
    }
  }

  stage {
    name = "DeployApplication"

    action {
      name            = "DeployToEKS"
      category        = "Build" # Se usa la categoría Build aunque la acción sea de Deploy
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.deploy_project.name
      }
    }
  }

  tags = merge(local.workspace.tags, {
    Name = local.workspace.pipeline_name
    Type = "CodePipeline"
  })
}