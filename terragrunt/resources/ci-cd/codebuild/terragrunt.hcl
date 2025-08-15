include "root" {
  path = find_in_parent_folders()
}

# include "common" {
#   path = "${dirname(find_in_parent_folders())}/common/common.hcl"
# }

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
    rds_endpoint = "mock-endpoint"
  }
}

dependency "role" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/security/iam/roles"
  mock_outputs = {
    codepipeline_role_arn = "mock*"
    codebuild_role_arn = "mock*"
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
  codepipeline_role_arn =  dependency.role.outputs.codepipeline_role_arn
  codebuild_role_arn =  dependency.role.outputs.codebuild_role_arn
  rds_endpoint = dependency.rds.outputs.db_instance_endpoint
}
