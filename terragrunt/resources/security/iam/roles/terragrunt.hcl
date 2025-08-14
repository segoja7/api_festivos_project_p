include "root" {
  path = find_in_parent_folders()
}

# dependency "secrets_manager" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/security/secrets_manager"
#   mock_outputs = {
#     secrets = {
#       jwt = {
#         arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock-jwt-secret"
#       },
#       dockerhub = {
#         arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock-dockerhub-secret"
#       }
#     }
#   }
# }
#
# dependency "rds" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/databases/rds/postgre"
#   mock_outputs = {
#     db_instance_master_user_secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock-rds"
#   }
# }
#
# dependency "s3" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/storage/s3"
#   mock_outputs = {
#     s3_bucket_arn = "arn:aws:s3:us-east-1:123456789012:secret:mock-s3"
#   }
# }
#
# dependency "codebuild" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/ci-cd/codebuild"
#   mock_outputs = {
#     build_project = "arn:aws:s3:us-east-1:123456789012:*"
#     db_bootstrap_project = "arn:aws:s3:us-east-1:123456789012:*"
#     deploy_project = "arn:aws:s3:us-east-1:123456789012:*"
#     github = "arn:aws:s3:us-east-1:123456789012:*"
#     cloudwatch_arn = "arn:aws:s3:us-east-1:123456789012:*"
#
#   }
# }
#
# dependency "eks" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/eks_cluster"
#   mock_outputs = {
#     eks_cluster_name = "mock*"
#   }
# }

# Las variables de 'parameters.tf' se cargan automáticamente.
# Aquí solo se definen las entradas que provienen de dependencias.
inputs = {
#   rds_secret_arn        = dependency.rds.outputs.db_instance_master_user_secret_arn
#   jwt_secret_arn        = dependency.secrets_manager.outputs.secrets["jwt"].arn
#   dockerhub_secret_arn  = dependency.secrets_manager.outputs.secrets["dockerhub"].arn
#   s3_bucket_arn =  dependency.s3.outputs.s3_bucket_arn
#   github_connection_arn =  dependency.codebuild.outputs.github_connection_arn
#   build_project_arn =  dependency.codebuild.outputs.build_project_arn
#   cloudwatch_logs_group_arn =  dependency.codebuild.outputs.cloudwatch_logs_group_arn
#   db_bootstrap_project_arn =  dependency.codebuild.outputs.db_bootstrap_project_arn
#   deploy_project_arn =  dependency.codebuild.outputs.deploy_project_arn
#   eks_cluster_name =  dependency.eks.outputs.cluster_name
 }

