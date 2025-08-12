include "root" {
  path = find_in_parent_folders()
}

# Dependencia del módulo VPC
dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/vpc"
  mock_outputs = {
    vpc_id                     = "vpc-12345678"
    database_subnets           = ["subnet-12345678", "subnet-87654321"]
    database_subnet_group_name = "mock-db-subnet-group"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Dependencia del Security Group para RDS
dependency "rds_security_group" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/security_group/rds"
  mock_outputs = {
    rds_security_group_ids = ["sg-12345678"]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Inputs con las dependencias de la VPC y Security Group
inputs = {
  # Dependencias de la VPC
  vpc_id                     = dependency.vpc.outputs.vpc_id
  database_subnets           = dependency.vpc.outputs.database_subnets
  database_subnet_group_name = dependency.vpc.outputs.database_subnet_group_name
  
  # Dependencia del Security Group
  vpc_security_group_ids = dependency.rds_security_group.outputs.rds_security_group_ids
}
