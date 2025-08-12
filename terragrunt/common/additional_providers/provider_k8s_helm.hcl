generate "k8s_helm_provider" {
  path      = "k8s_helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
################################################################################
# Kubernetes Access for EKS Cluster
################################################################################

# Data source para obtener la región actual
data "aws_region" "current" {}

# Configuración de versiones requeridas
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

# Provider de Kubernetes para EKS
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # Requiere AWS CLI instalado localmente donde se ejecuta Terraform
    args = [
      "eks", "get-token", 
      "--cluster-name", var.cluster_name, 
      "--region", data.aws_region.current.name,
      "--profile", var.profile[terraform.workspace]["profile"]
    ]
  }
}

# Provider de Helm para EKS
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # Requiere AWS CLI instalado localmente donde se ejecuta Terraform
      args = [
        "eks", "get-token", 
        "--cluster-name", var.cluster_name, 
        "--region", data.aws_region.current.name,
        "--profile", var.profile[terraform.workspace]["profile"]
      ]
    }
  }
}

EOF
}