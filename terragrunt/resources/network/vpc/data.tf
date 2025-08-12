################################################################################
# Data Sources
################################################################################

# Obtener zonas de disponibilidad disponibles
data "aws_availability_zones" "available" {
  state = "available"
  
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Obtener información de la región actual
data "aws_region" "current" {}

# Obtener información de la cuenta actual
data "aws_caller_identity" "current" {}
