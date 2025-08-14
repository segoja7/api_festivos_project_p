################################################################################
# Variables for EKS Cluster
################################################################################

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (optional, for load balancers)"
  type        = list(string)
  default     = []
}

variable "codebuild_role_arn" {
  description = "codebuild role arn"
  type = string
}