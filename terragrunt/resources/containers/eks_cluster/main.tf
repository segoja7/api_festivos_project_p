################################################################################
# EKS Cluster Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.7"

  # Configuración básica del cluster
  name               = local.workspace["name"]
  kubernetes_version = local.workspace["kubernetes_version"]

  # Configuración de VPC y subnets
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  # Configuración de endpoints
  endpoint_private_access      = local.workspace["endpoint_private_access"]
  endpoint_public_access       = local.workspace["endpoint_public_access"]
  endpoint_public_access_cidrs = local.workspace["endpoint_public_access_cidrs"]

  # Configuración de autenticación
  authentication_mode                       = local.workspace["authentication_mode"]
  enable_cluster_creator_admin_permissions = local.workspace["enable_cluster_creator_admin_permissions"]

  # Configuración de logs de CloudWatch
  enabled_log_types                      = local.workspace["enabled_log_types"]
  create_cloudwatch_log_group           = local.workspace["create_cloudwatch_log_group"]
  cloudwatch_log_group_retention_in_days = local.workspace["cloudwatch_log_group_retention_in_days"]

  # Configuración de red
  ip_family         = local.workspace["ip_family"]
  service_ipv4_cidr = local.workspace["service_ipv4_cidr"]

  # Addons del cluster
  addons = local.workspace["addons"]

  # EKS Managed Node Groups con subnets dinámicos
  eks_managed_node_groups = {
    for k, v in local.workspace["eks_managed_node_groups"] : k => merge(v, {
      subnet_ids = var.private_subnet_ids
    })
  }

  # Access Entries
  access_entries = local.workspace["access_entries"]

  # Configuración de encriptación
  encryption_config = local.workspace["encryption_config"]

  # KMS Key para encriptación
  create_kms_key                      = local.workspace["create_kms_key"]
  kms_key_description                 = local.workspace["kms_key_description"]
  kms_key_deletion_window_in_days     = local.workspace["kms_key_deletion_window_in_days"]
  enable_kms_key_rotation             = local.workspace["enable_kms_key_rotation"]

  # IRSA (IAM Roles for Service Accounts)
  enable_irsa = local.workspace["enable_irsa"]

  # Tags
  tags         = local.workspace["tags"]
  cluster_tags = local.workspace["cluster_tags"]
}
