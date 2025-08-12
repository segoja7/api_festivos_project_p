# Ejemplo de uso del provider K8s/Helm

## En el terragrunt.hcl del módulo que necesite K8s/Helm:

```hcl
include "root" {
  path = find_in_parent_folders()
}

# Incluir el provider de K8s/Helm
include "k8s_helm_provider" {
  path = find_in_parent_folders("common/additional_providers/provider_k8s_helm.hcl")
}

# Dependencia del cluster EKS
dependency "eks" {
  config_path = "${get_parent_terragrunt_dir("root")}/resources/compute/eks"
  mock_outputs = {
    cluster_name                         = "mock-cluster"
    cluster_endpoint                     = "https://mock.eks.us-east-1.amazonaws.com"
    cluster_certificate_authority_data   = "LS0tLS1CRUdJTi..."
    cluster_platform_version            = "eks.1"
    oidc_provider_arn                   = "arn:aws:iam::123456789012:oidc-provider/mock"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs                           = false
}

inputs = {
  # Variables requeridas por el provider K8s/Helm
  cluster_name                         = dependency.eks.outputs.cluster_name
  cluster_endpoint                     = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data   = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_platform_version            = dependency.eks.outputs.cluster_platform_version
  oidc_provider_arn                   = dependency.eks.outputs.oidc_provider_arn
}
```

## Estructura de archivos resultante en el módulo:

```
resources/apps/helm-charts/
├── terragrunt.hcl          # Con include del provider K8s/Helm
├── main.tf                 # Tu código Terraform
├── parameters.tf           # Configuración local
├── outputs.tf              # Outputs del módulo
├── provider.tf             # Generado por common.hcl (AWS)
└── k8s_helm_provider.tf    # Generado por provider_k8s_helm.hcl
```

## Ventajas:

1. **Modular**: Solo incluyes el provider donde lo necesitas
2. **Dinámico**: Se adapta al workspace actual
3. **Dependencias**: Se conecta automáticamente al cluster EKS
4. **Consistente**: Usa el mismo patrón que el provider AWS
