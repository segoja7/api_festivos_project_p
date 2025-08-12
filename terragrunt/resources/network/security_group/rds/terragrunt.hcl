include "root" {
  path = find_in_parent_folders()
}

# Dependencia del módulo VPC
dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/network/vpc"
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Dependencia del cluster EKS para obtener el security group de los nodos
dependency "eks" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/containers/eks_cluster"
  mock_outputs = {
    node_security_group_id = "sg-12345678"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

# Inputs con las dependencias de la VPC y EKS
inputs = {
  # Dependencias de la VPC
  vpc_id = dependency.vpc.outputs.vpc_id
  
  # Security group de los nodos EKS para permitir acceso a RDS
  eks_node_security_group_id = dependency.eks.outputs.node_security_group_id
}
