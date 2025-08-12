################################################################################
# EKS Blueprints Addons Outputs
################################################################################

# EKS Addons nativos
output "eks_addons" {
  description = "Map of attributes for each EKS addons enabled"
  value       = module.eks_blueprints_addons.eks_addons
}

# AWS Load Balancer Controller
output "aws_load_balancer_controller" {
  description = "Map of attributes of the AWS Load Balancer Controller Helm release and IRSA created"
  value       = module.eks_blueprints_addons.aws_load_balancer_controller
}

# External Secrets
output "external_secrets" {
  description = "Map of attributes of the External Secrets Helm release and IRSA created"
  value       = module.eks_blueprints_addons.external_secrets
}

# Ingress NGINX
output "ingress_nginx" {
  description = "Map of attributes of the Ingress NGINX Helm release created"
  value       = module.eks_blueprints_addons.ingress_nginx
}

# Metrics Server
output "metrics_server" {
  description = "Map of attributes of the Metrics Server Helm release created"
  value       = module.eks_blueprints_addons.metrics_server
}

# AWS for FluentBit
output "aws_for_fluentbit" {
  description = "Map of attributes of the AWS for FluentBit Helm release and IRSA created"
  value       = module.eks_blueprints_addons.aws_for_fluentbit
}

# AWS CloudWatch Metrics
output "aws_cloudwatch_metrics" {
  description = "Map of attributes of the AWS CloudWatch Metrics Helm release and IRSA created"
  value       = module.eks_blueprints_addons.aws_cloudwatch_metrics
}

# Secrets Store CSI Driver
output "secrets_store_csi_driver" {
  description = "Map of attributes of the Secrets Store CSI Driver Helm release created"
  value       = module.eks_blueprints_addons.secrets_store_csi_driver
}

# Secrets Store CSI Driver Provider AWS
output "secrets_store_csi_driver_provider_aws" {
  description = "Map of attributes of the AWS Secrets Store CSI Driver Provider Helm release created"
  value       = module.eks_blueprints_addons.secrets_store_csi_driver_provider_aws
}

# GitOps Metadata (útil para ArgoCD si se usa después)
output "gitops_metadata" {
  description = "GitOps Bridge metadata"
  value       = module.eks_blueprints_addons.gitops_metadata
}
