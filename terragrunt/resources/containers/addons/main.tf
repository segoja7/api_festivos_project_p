################################################################################
# EKS Blueprints Addons Module
################################################################################

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.22.0"

  # Variables requeridas del cluster EKS
  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  # EKS Addons nativos
  eks_addons = local.workspace["eks_addons"]

  # AWS Load Balancer Controller
  enable_aws_load_balancer_controller = local.workspace["enable_aws_load_balancer_controller"]
  aws_load_balancer_controller        = local.workspace["aws_load_balancer_controller"]

  # External Secrets Operator
  enable_external_secrets                    = local.workspace["enable_external_secrets"]
  external_secrets                          = local.workspace["external_secrets"]
  external_secrets_secrets_manager_arns     = local.workspace["external_secrets_secrets_manager_arns"]
  external_secrets_kms_key_arns             = local.workspace["external_secrets_kms_key_arns"]

  # Ingress NGINX Controller
  enable_ingress_nginx = local.workspace["enable_ingress_nginx"]
  ingress_nginx        = local.workspace["ingress_nginx"]

  # Metrics Server
  # enable_metrics_server = local.workspace["enable_metrics_server"]
  # metrics_server        = local.workspace["metrics_server"]

  # Observabilidad - CloudWatch
  enable_aws_cloudwatch_metrics = local.workspace["enable_aws_cloudwatch_metrics"]
  
  # enable_aws_for_fluentbit       = local.workspace["enable_aws_for_fluentbit"]
  # aws_for_fluentbit              = local.workspace["aws_for_fluentbit"]
  # aws_for_fluentbit_cw_log_group = local.workspace["aws_for_fluentbit_cw_log_group"]

  # Secrets Store CSI Driver
  enable_secrets_store_csi_driver              = local.workspace["enable_secrets_store_csi_driver"]
  secrets_store_csi_driver                     = local.workspace["secrets_store_csi_driver"]
  
  enable_secrets_store_csi_driver_provider_aws = local.workspace["enable_secrets_store_csi_driver_provider_aws"]
  secrets_store_csi_driver_provider_aws        = local.workspace["secrets_store_csi_driver_provider_aws"]

  # Prometheus and Grafana
  enable_kube_prometheus_stack = local.workspace["enable_kube_prometheus_stack"]
  kube_prometheus_stack        = local.workspace["kube_prometheus_stack"]

  # Addons deshabilitados
  enable_cert_manager = local.workspace["enable_cert_manager"]
  enable_external_dns = local.workspace["enable_external_dns"]

  # Tags
  tags = local.workspace["tags"]
}
