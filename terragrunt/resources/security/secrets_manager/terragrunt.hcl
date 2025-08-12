include "root" {
  path = find_in_parent_folders()
}

# Temporarily disabled dependency while we fix the policy issue
# dependency "eks_addons" {
#   config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/addons"
#   mock_outputs = {
#     external_secrets = {
#       iam_role_arn = "arn:aws:iam::476114125818:role/external-secrets-mock"
#     }
#   }
#   mock_outputs_merge_strategy_with_state = "shallow"
#   skip_outputs                           = false
# }

inputs = {
  # external_secrets_role_arn = dependency.eks_addons.outputs.external_secrets.iam_role_arn
}
