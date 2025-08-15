################################################################################
# CodePipeline Infrastructure
################################################################################

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
      name             = "BuildAPI"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["api_build_output"]
      version          = "1"
      run_order        = 1

      configuration = {
        ProjectName = var.api_build_project_name
      }
    }

    action {
      name             = "BuildFrontend"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["frontend_build_output"]
      version          = "1"
      run_order        = 1

      configuration = {
        ProjectName = var.frontend_build_project_name
      }
    }
  }

  stage {
    name = "DatabaseBootstrap"

    action {
      name            = "BootstrapDB"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = var.db_bootstrap_project_name
      }
    }
  }

  stage {
    name = "DeployApplication"

    action {
      name            = "DeployToEKS"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["api_build_output", "frontend_build_output"]
      version         = "1"
      run_order       = 1

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
