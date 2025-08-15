variable "ecr_repository_name" {
  description = "The name of the ECR repository for the application."
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "rds_secret_arn" {
  description = "The ARN of the RDS secret in Secrets Manager."
  type        = string
}

variable "jwt_secret_arn" {
  description = "The ARN of the JWT secret in Secrets Manager."
  type        = string
}

variable "dockerhub_secret_arn" {
  description = "The ARN of the Docker Hub credentials secret in Secrets Manager."
  type        = string
}

variable "codepipeline_role_arn" {
  description = "codepipeline_role_arn"
  type        = string
}

variable "codebuild_role_arn" {
  description = "codebuild_role_arn"
  type        = string
}

variable "s3_bucket" {
  description = "s3_bucket"
  type = string
}

variable "github_connection_arn" {
  description = "github_connection_arn"
  type = string
}

variable "api_build_project_name" {
  description = "API build project name"
  type = string
}

variable "frontend_build_project_name" {
  description = "Frontend build project name"
  type = string
}

variable "db_bootstrap_project_name" {
  description = "Database bootstrap project name"
  type = string
}

variable "deploy_project_name" {
  description = "Deploy project name"
  type = string
}
