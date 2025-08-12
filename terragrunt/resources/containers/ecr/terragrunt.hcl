include "root" {
  path = find_in_parent_folders()
}

# ECR no requiere dependencias externas ya que es un servicio regional
# que no depende de VPC, subnets u otros recursos de red

inputs = {
  # No se requieren inputs externos para ECR
}
