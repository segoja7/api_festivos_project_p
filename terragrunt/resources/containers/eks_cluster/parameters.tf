################################################################################
# EKS Cluster Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # Configuración básica del cluster
      name               = "arquitectura-avanzada-eks"
      kubernetes_version = "1.33"  # Versión más reciente disponible
      
      # Configuración de endpoints
      endpoint_private_access = true   # Acceso privado habilitado
      endpoint_public_access  = true   # Acceso público temporal para instalar addons
      endpoint_public_access_cidrs = ["0.0.0.0/0"]  # Solo si se habilita acceso público
      
      # Modo de autenticación
      authentication_mode = "API_AND_CONFIG_MAP"
      enable_cluster_creator_admin_permissions = true
      
      # Logs del control plane
      enabled_log_types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler"
      ]
      
      # CloudWatch logs
      create_cloudwatch_log_group = true
      cloudwatch_log_group_retention_in_days = 7  # 7 días para desarrollo
      
      # Configuración de red
      ip_family = "ipv4"
      service_ipv4_cidr = "172.20.0.0/16"  # CIDR para servicios de Kubernetes
      
      # Addons esenciales
      addons = {
        coredns = {
          most_recent = true
        }
        eks-pod-identity-agent = {
          before_compute = true
          most_recent = true
        }
        kube-proxy = {
          most_recent = true
        }
        vpc-cni = {
          before_compute = true
          most_recent = true
        }
        aws-ebs-csi-driver = {
          most_recent = true
        }
      }
      
      # EKS Managed Node Groups
      eks_managed_node_groups = {
        main = {
          # Configuración básica del node group
          name = "main-node-group"
          
          # AMI y tipo de instancia
          ami_type       = "AL2023_x86_64_STANDARD"  # Amazon Linux 2023
          instance_types = ["t3.medium"]  # Instancia económica para desarrollo
          capacity_type  = "ON_DEMAND"   # On-demand para estabilidad
          
          # Configuración de escalado
          min_size     = 1
          max_size     = 3
          desired_size = 2
          
          # Configuración de disco
          disk_size = 20  # GB
          
          # Configuración de actualización
          update_config = {
            max_unavailable_percentage = 25
          }
          
          # Labels para el node group
          labels = {
            Environment = "dev"
            NodeGroup   = "main"
            Project     = "arquitectura-avanzada"
          }
          
          # Taints (ninguno para el node group principal)
          taints = {}
          
          # Tags específicos del node group
          tags = {
            Name = "arquitectura-avanzada-eks-main-nodes"
            Type = "EKS Managed Node Group"
          }
        }
      }
      
      # Access entries - Permisos de acceso al cluster
      access_entries = {
        # Usuario udea con permisos de administrador completo

        
        # Usuario iamadmin_gnral con permisos de administrador completo
       iamadmin_user = {
         principal_arn = "arn:aws:iam::476114125818:role/arquitectura-avanzada-codebuild-role"
         type         = "STANDARD"
          
         policy_associations = {
           admin = {
             policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
             access_scope = {
               type = "cluster"
             }
           }
         }
       }
      }
      
      # Configuración de encriptación
      encryption_config = {
        resources = ["secrets"]
      }
      
      # KMS Key para encriptación
      create_kms_key = true
      kms_key_description = "EKS cluster encryption key"
      kms_key_deletion_window_in_days = 7  # Para desarrollo
      enable_kms_key_rotation = true
      
      # IRSA (IAM Roles for Service Accounts)
      enable_irsa = true
      
      # Tags generales
      tags = {
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Container"
        Service     = "EKS"
        Purpose     = "Kubernetes Cluster"
      }
      
      # Tags específicos del cluster
      cluster_tags = {
        Name = "arquitectura-avanzada-eks-cluster"
        Type = "EKS Cluster"
      }
    }
    
    dev = {
      # Configuraciones específicas para desarrollo
    }
    
    prod = {
      # Configuraciones específicas para producción
    }
  }
  
  # Lógica para seleccionar el ambiente
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}
