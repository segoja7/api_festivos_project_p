################################################################################
# CodePipeline Infrastructure
################################################################################

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}






# ################################################################################
# # CloudWatch Logs para CodeBuild
# ################################################################################
#
# resource "aws_cloudwatch_log_group" "codebuild_logs" {
#   name              = local.workspace.cloudwatch_logs_group_name
#   retention_in_days = local.workspace.cloudwatch_logs_retention_days
#
#   tags = merge(local.workspace.tags, {
#     Name = local.workspace.cloudwatch_logs_group_name
#     Type = "CodeBuild Logs"
#   })
# }
#
#
#
# ################################################################################
# # CodeBuild Projects
# ################################################################################
#
# resource "aws_codebuild_project" "build_project" {
#   name          = local.workspace.codebuild_project_name
#   description   = "Build project for ${local.workspace.pipeline_name}"
#   service_role  = aws_iam_role.codebuild_role.arn
#
#   artifacts {
#     type = "CODEPIPELINE"
#   }
#
#   environment {
#     compute_type                = local.workspace.codebuild_compute_type
#     image                       = local.workspace.codebuild_image
#     type                        = local.workspace.codebuild_type
#     image_pull_credentials_type = "CODEBUILD"
#     privileged_mode             = local.workspace.codebuild_privileged_mode
#
#     dynamic "environment_variable" {
#       for_each = local.workspace.environment_variables
#       content {
#         name  = environment_variable.value.name
#         value = environment_variable.value.value
#         type  = environment_variable.value.type
#       }
#     }
#   }
#
#   logs_config {
#     cloudwatch_logs {
#       group_name = aws_cloudwatch_log_group.codebuild_logs.name
#     }
#   }
#
#   source {
#     type      = "CODEPIPELINE"
#     buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-fase1-build.yml"
#   }
#
#   tags = merge(local.workspace.tags, {
#     Name = local.workspace.codebuild_project_name
#     Type = "CodeBuild Project"
#   })
# }
#
# resource "aws_codebuild_project" "db_bootstrap_project" {
#   name          = "${local.workspace.codebuild_project_name}-db-bootstrap"
#   description   = "Database bootstrap project for ${local.workspace.pipeline_name}"
#   service_role  = aws_iam_role.codebuild_role.arn
#
#   artifacts {
#     type = "CODEPIPELINE"
#   }
#
#   environment {
#     compute_type                = local.workspace.codebuild_compute_type
#     image                       = local.workspace.codebuild_image
#     type                        = local.workspace.codebuild_type
#     image_pull_credentials_type = "CODEBUILD"
#     privileged_mode             = false
#
#     dynamic "environment_variable" {
#       for_each = merge(local.workspace.environment_variables, {
#         RDS_SECRET_ARN = {
#           name  = "RDS_SECRET_ARN"
#           value = var.rds_secret_arn
#           type  = "PLAINTEXT"
#         }
#       })
#       content {
#         name  = environment_variable.value.name
#         value = environment_variable.value.value
#         type  = environment_variable.value.type
#       }
#     }
#   }
#
#   logs_config {
#     cloudwatch_logs {
#       group_name = aws_cloudwatch_log_group.codebuild_logs.name
#     }
#   }
#
#   source {
#     type      = "CODEPIPELINE"
#     buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-db-bootstrap.yml"
#   }
#
#   tags = merge(local.workspace.tags, {
#     Name = "${local.workspace.codebuild_project_name}-db-bootstrap"
#     Type = "CodeBuild Project"
#   })
# }
#
# resource "aws_codebuild_project" "deploy_project" {
#   name          = "${local.workspace.codebuild_project_name}-deploy"
#   description   = "Deploy project for ${local.workspace.pipeline_name}"
#   service_role  = aws_iam_role.codebuild_role.arn
#
#   artifacts {
#     type = "CODEPIPELINE"
#   }
#
#   environment {
#     compute_type                = local.workspace.codebuild_compute_type
#     image                       = local.workspace.codebuild_image
#     type                        = local.workspace.codebuild_type
#     image_pull_credentials_type = "CODEBUILD"
#     privileged_mode             = false
#
#     dynamic "environment_variable" {
#       for_each = local.workspace.environment_variables
#       content {
#         name  = environment_variable.value.name
#         value = environment_variable.value.value
#         type  = environment_variable.value.type
#       }
#     }
#   }
#
#   logs_config {
#     cloudwatch_logs {
#       group_name = aws_cloudwatch_log_group.codebuild_logs.name
#     }
#   }
#
#   source {
#     type      = "CODEPIPELINE"
#     buildspec = "terragrunt/resources/ci-cd/codepipeline/buildspecs/buildspec-deploy.yml"
#   }
#
#   tags = merge(local.workspace.tags, {
#     Name = "${local.workspace.codebuild_project_name}-deploy"
#     Type = "CodeBuild Project"
#   })
# }

################################################################################
# CodePipeline
################################################################################

resource "aws_codepipeline" "pipeline" {
  name     = local.workspace.pipeline_name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.s3_bucket
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
        ConnectionArn    = var.github_connection_arn
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
        ProjectName = var.build_project_name
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
        ProjectName = var.db_bootstrap_project_name
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
        ProjectName = var.deploy_project_name
      }
    }
  }

  tags = merge(local.workspace.tags, {
    Name = local.workspace.pipeline_name
    Type = "CodePipeline"
  })
}