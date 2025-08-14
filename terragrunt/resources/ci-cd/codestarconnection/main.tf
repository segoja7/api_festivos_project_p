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

