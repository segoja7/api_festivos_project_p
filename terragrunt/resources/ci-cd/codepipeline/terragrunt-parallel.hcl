include "root" {
  path = find_in_parent_folders()
}

dependency "ecr" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/ecr"
  mock_outputs = {
    repository_url = "mock-ecr-url"
    repository_name = "mock-repo"
  }
}

dependency "eks_cluster" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/eks_cluster"
  mock_outputs = {
    cluster_name = "mock-cluster"
    cluster_endpoint = "https://mock.eks.us-east-1.amazonaws.com"
    cluster_arn = "arn:aws:eks:us-east-1:123456789012:cluster/mock"
  }
}

dependency "secrets_manager" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/security/secrets_manager"
  mock_outputs = {
    secrets = {
      jwt = {
        arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock-jwt-secret"
      },
      dockerhub = {
        arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock-dockerhub-secret"
      }
    }
  }
}

dependency "rds" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/databases/rds/postgre"
  mock_outputs = {
    db_instance_master_user_secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock-rds"
  }
}

dependency "role" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/security/iam/roles"
  mock_outputs = {
    codepipeline_role_arn = "mock*"
    codebuild_role_arn = "mock*"
  }
}

dependency "s3" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/storage/s3"
  mock_outputs = {
    s3_bucket = "mock*"
  }
}

dependency "github_connection" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/ci-cd/codestarconnection"
  mock_outputs = {
    github_connection_arn = "mock*"
  }
}

dependency "codebuild" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/ci-cd/codebuild"
  mock_outputs = {
    api_build_project_name = "mock*"
    frontend_build_project_name = "mock*"
    db_bootstrap_project_name = "mock*"
    deploy_project_name = "mock*"
  }
}

# Las variables de 'parameters.tf' se cargan automáticamente.
# Aquí solo se definen las entradas que provienen de dependencias.
inputs = {
  ecr_repository_name   = dependency.ecr.outputs.repository_name
  eks_cluster_name      = dependency.eks_cluster.outputs.cluster_name
  rds_secret_arn        = dependency.rds.outputs.db_instance_master_user_secret_arn
  jwt_secret_arn        = dependency.secrets_manager.outputs.secrets["jwt"].arn
  dockerhub_secret_arn  = dependency.secrets_manager.outputs.secrets["dockerhub"].arn
  s3_bucket =  dependency.s3.outputs.s3_bucket
  github_connection_arn =  dependency.github_connection.outputs.github_connection_arn
  api_build_project_name =  dependency.codebuild.outputs.api_build_project_name
  frontend_build_project_name =  dependency.codebuild.outputs.frontend_build_project_name
  db_bootstrap_project_name =  dependency.codebuild.outputs.db_bootstrap_project_name
  deploy_project_name =  dependency.codebuild.outputs.deploy_project_name
  codepipeline_role_arn =  dependency.role.outputs.codepipeline_role_arn
  codebuild_role_arn =  dependency.role.outputs.codebuild_role_arn
}
