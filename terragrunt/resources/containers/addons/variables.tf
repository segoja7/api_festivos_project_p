################################################################################
# Variables for EKS Blueprints Addons
################################################################################

# Variables adicionales no incluidas en k8s_helm_provider.tf
variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster (i.e.: 1.33)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  type        = string
}

variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The OIDC provider ARN for the EKS cluster"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "The CA data for the EKS cluster"
  type        = string
}

variable "profile" {
  description = "AWS profile configurations for different environments"
  type = map(object({
    profile = string
  }))
  default = {
    default = {
      profile = "udea"
    }
    dev = {
      profile = "udea"
    }
    prod = {
      profile = "udea-prod"
    }
  }
}