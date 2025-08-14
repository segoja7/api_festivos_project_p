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
  type = string
  description = "codepipeline_role_arn"
}

variable "codebuild_role_arn" {
  type = string
  description = "codebuild_role_arn"
}