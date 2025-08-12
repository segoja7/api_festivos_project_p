include "root" {
  path = find_in_parent_folders()
}

# Incluir providers adicionales de Kubernetes y Helm
include "k8s_helm_provider" {
  path = find_in_parent_folders("/common/additional_providers/provider_k8s_helm.hcl")
}


# Dependencia del cluster EKS
dependency "eks" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/eks_cluster"
  mock_outputs = {
    cluster_name                         = "arquitectura-avanzada-eks"
    cluster_endpoint                     = "https://mock-endpoint.eks.us-east-1.amazonaws.com"
    cluster_version                      = "1.33"
    oidc_provider_arn                    = "arn:aws:iam::476114125818:oidc-provider/mock-oidc-provider"
    cluster_certificate_authority_data   = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Dependencia del VPC (para AWS Load Balancer Controller)
dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/vpc"
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

inputs = {
  # Variables requeridas del cluster EKS
  cluster_name                       = dependency.eks.outputs.cluster_name
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_version                    = dependency.eks.outputs.cluster_version
  oidc_provider_arn                  = dependency.eks.outputs.oidc_provider_arn
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  
  # Variable adicional para AWS Load Balancer Controller
  vpc_id = dependency.vpc.outputs.vpc_id
}
