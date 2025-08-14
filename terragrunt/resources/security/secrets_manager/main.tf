################################################################################
# AWS Secrets Manager Module
################################################################################

module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.3.1"

  for_each = local.workspace.secrets

  # Secret configuration
  name_prefix             = each.value.secret_name
  description             = each.value.secret_description
  recovery_window_in_days = each.value.recovery_window_in_days
  kms_key_id              = each.value.kms_key_id

  # Policy configuration
  create_policy       = each.value.create_policy
  block_public_policy = each.value.block_public_policy
  policy_statements   = each.value.policy_statements

  # Secret content (only if not using random password)
  create_random_password = each.value.create_random_password
  secret_string          = each.value.secret_string
  secret_binary          = each.value.secret_binary
  
  # Version management
  ignore_secret_changes = each.value.ignore_secret_changes
  version_stages        = each.value.version_stages

  # Rotation configuration
  enable_rotation     = each.value.enable_rotation
  rotation_lambda_arn = each.value.rotation_lambda_arn
  rotation_rules      = each.value.rotation_rules

  # Replica configuration
  replica                        = each.value.replica
  force_overwrite_replica_secret = each.value.force_overwrite_replica_secret

  # Tags
  tags = each.value.tags
}