################################################################################
# RDS Security Group Variables - Solo para dependencias entre módulos
################################################################################

# Dependencias de la VPC
variable "vpc_id" {
  description = "ID de la VPC donde se creará el security group"
  type        = string
}

variable "eks_node_security_group_id" {
  description = "ID del security group de los nodos EKS desde donde se permitirá el acceso a RDS"
  type        = string
}
