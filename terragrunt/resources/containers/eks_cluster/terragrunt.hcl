include "root" {
  path = find_in_parent_folders()
}

# Dependencia del módulo VPC
dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/vpc"
  mock_outputs = {
    vpc_id          = "vpc-12345678"
    private_subnets = ["subnet-12345678", "subnet-87654321"]
    public_subnets  = ["subnet-11111111", "subnet-22222222"]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Dependencia del módulo VPC Endpoints
dependency "vpc_endpoints" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/vpc_endpoints"
  mock_outputs = {
    endpoints = {}
    security_group_id = "sg-12345678"
    ecr_api_endpoint_id = "vpce-12345678"
    ecr_dkr_endpoint_id = "vpce-87654321"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

inputs = {
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnets
  public_subnet_ids  = dependency.vpc.outputs.public_subnets

  # Añadido para dar permisos al rol de CodeBuild dentro del clúster EKS
  # Usando el método moderno de Access Entries
}