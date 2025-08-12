################################################################################
# RDS Variables - Solo para dependencias entre módulos
################################################################################

# Dependencias de la VPC
variable "vpc_id" {
  description = "ID de la VPC donde se desplegará la RDS"
  type        = string
}

variable "database_subnets" {
  description = "Lista de IDs de las subnets de base de datos"
  type        = list(string)
}

variable "database_subnet_group_name" {
  description = "Nombre del grupo de subnets de base de datos creado por el módulo VPC"
  type        = string
}

# Dependencias de Security Groups (cuando se cree el módulo)
variable "vpc_security_group_ids" {
  description = "Lista de IDs de security groups para la RDS"
  type        = list(string)
  default     = []
}
