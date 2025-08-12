include "root" {
  path = find_in_parent_folders()
}

# Dependencia del módulo VPC
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id                  = "vpc-00000000"
    vpc_cidr_block          = "10.0.0.0/16"
    private_subnets         = ["subnet-00000000", "subnet-11111111"]
    private_route_table_ids = ["rt-00000000", "rt-11111111"]
    public_route_table_ids  = ["rt-22222222", "rt-33333333"]
    intra_route_table_ids   = []
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Inputs con las dependencias de la VPC
inputs = {
  vpc_id                  = dependency.vpc.outputs.vpc_id
  vpc_cidr_block          = dependency.vpc.outputs.vpc_cidr_block
  private_subnets         = dependency.vpc.outputs.private_subnets
  private_route_table_ids = dependency.vpc.outputs.private_route_table_ids
  public_route_table_ids  = dependency.vpc.outputs.public_route_table_ids
}