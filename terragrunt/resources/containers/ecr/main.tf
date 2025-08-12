################################################################################
# ECR Module
################################################################################

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.4.0"

  # Configuración básica del repositorio
  repository_name = local.workspace["repository_name"]
  repository_type = local.workspace["repository_type"]

  # Configuración de seguridad
  repository_image_tag_mutability = local.workspace["repository_image_tag_mutability"]
  repository_image_scan_on_push   = local.workspace["repository_image_scan_on_push"]
  repository_force_delete         = local.workspace["repository_force_delete"]

  # Configuración de encriptación
  repository_encryption_type = local.workspace["repository_encryption_type"]

  # Política de ciclo de vida
  repository_lifecycle_policy = local.workspace["repository_lifecycle_policy"]

  # Permisos de acceso
  repository_read_write_access_arns = local.workspace["repository_read_write_access_arns"]

  # Configuración de creación de recursos
  create_repository        = local.workspace["create_repository"]
  create_lifecycle_policy  = local.workspace["create_lifecycle_policy"]
  create_repository_policy = local.workspace["create_repository_policy"]
  attach_repository_policy = local.workspace["attach_repository_policy"]

  # Tags
  tags = local.workspace["tags"]
}
