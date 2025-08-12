include "root" {
  path = find_in_parent_folders()
}

#This is a example for dependency's
dependency "#add name" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/security/iam/roles" #Update path
  mock_outputs = {
    iam_instance_profile = "xxx"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

inputs = {
  iam_instance_profile = dependency.roles.outputs.iam_instance_profile_name
}
