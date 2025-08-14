# locals {
#   workspace = get_env("TERRAGRUNT_WORKSPACE", "dev")
# }

# stage/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "bucket-s3-udea-project-dev-71d2a3a4",
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamodb-table-terraform-udea-project-dev-71d2a3a4",
    profile        = "udea"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
      region = "us-east-1"
      profile = "udea"
  }
  EOF
}
