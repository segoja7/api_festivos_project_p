################################################################################
# CodePipeline Infrastructure
################################################################################

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



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
# CodeBuild Projects
################################################################################

resource "aws_codebuild_project" "build_project" {
  name          = local.workspace.codebuild_project_name
  description   = "Build project for ${local.workspace.pipeline_name}"
  service_role  = var.codebuild_role_arn

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
    buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-fase1-build-fullstack.yml"
  }

  tags = merge(local.workspace.tags, {
    Name = local.workspace.codebuild_project_name
    Type = "CodeBuild Project"
  })
}

resource "aws_codebuild_project" "db_bootstrap_project" {
  name          = "${local.workspace.codebuild_project_name}-db-bootstrap"
  description   = "Database bootstrap project for ${local.workspace.pipeline_name}"
  service_role  = var.codebuild_role_arn

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
  service_role  = var.codebuild_role_arn

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
    buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-deploy-fullstack.yml"
  }

  tags = merge(local.workspace.tags, {
    Name = "${local.workspace.codebuild_project_name}-deploy"
    Type = "CodeBuild Project"
  })
}

