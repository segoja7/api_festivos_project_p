################################################################################
# EKS Blueprints Addons Parameters - Terragrunt Native Approach
################################################################################

locals {
  env = {
    default = {
      # EKS Addons nativos (gestionados por AWS)
      eks_addons = {
        # AWS EBS CSI Driver - Para volúmenes persistentes
        # aws-ebs-csi-driver = {
        #   most_recent                 = false
        #   resolve_conflicts_on_create = "OVERWRITE"
        # }
        
        # # CoreDNS - DNS del cluster
        # coredns = {
        #   most_recent                 = false
        #   resolve_conflicts_on_create = "OVERWRITE"
        # }
        
        # # VPC CNI - Networking del cluster
        # vpc-cni = {
        #   most_recent                 = false
        #   before_compute              = false
        #   resolve_conflicts_on_create = "OVERWRITE"
        # }
        
        # # Kube Proxy - Proxy de red
        # kube-proxy = {
        #   most_recent                 = false
        #   resolve_conflicts_on_create = "OVERWRITE"
        # }
      }
      
      # Addons esenciales habilitados
      enable_aws_load_balancer_controller = true  # ALB/NLB Controller
      enable_external_secrets             = true  # Secretos desde AWS Secrets Manager
      enable_ingress_nginx               = true  # Ingress Controller
      # enable_metrics_server              = true  # Métricas de recursos
      
      # Observabilidad
      enable_aws_cloudwatch_metrics = true  # Container Insights
      # enable_aws_for_fluentbit      = true  # Logs centralizados
      
      # Seguridad y secretos
      enable_secrets_store_csi_driver              = true  # CSI Secrets Store
      enable_secrets_store_csi_driver_provider_aws = true  # AWS Secrets Provider
      
      # Addons NO habilitados (usaremos ACM en lugar de cert-manager)
      enable_cert_manager = false
      enable_external_dns = false  # Por ahora no necesario
      
      # Configuración del AWS Load Balancer Controller
      aws_load_balancer_controller = {
        chart_version = "1.8.1"
        namespace     = "kube-system"
        
        set = [
          {
            name  = "clusterName"
            value = var.cluster_name
          },
          {
            name  = "serviceAccount.create"
            value = "true"
          },
          {
            name  = "serviceAccount.name"
            value = "aws-load-balancer-controller"
          },
          {
            name  = "region"
            value = "us-east-1"
          },
          {
            name  = "vpcId"
            value = var.vpc_id
          }
        ]
        
        tags = {
          Name = "aws-load-balancer-controller"
        }
      }
      
      # Configuración de External Secrets
      external_secrets = {
        chart_version = "0.9.11"
        namespace     = "festivos-api" #"external-secrets-system"
        create_namespace = true
        set = [
          {
            name  = "installCRDs"
            value = "true"
          },
          {
            name  = "webhook.port"
            value = "9443"
          },
          # {
          #   name  = "serviceAccount.create"
          #   value = "true"
          # },
          # {
          #   name  = "serviceAccount.name"
          #   value = "external-secrets-sa"
          # }
        ]
        
        tags = {
          Name = "external-secrets-operator"
        }
      }
      
      # Configuración de Ingress NGINX
      ingress_nginx = {
        chart_version = "4.8.3"
        namespace     = "ingress-nginx"
        
        set = [
          {
            name  = "controller.service.type"
            value = "ClusterIP"  # Usaremos ALB como punto de entrada
          },
          {
            name  = "controller.service.internal.enabled"
            value = "true"
          },
          {
            name  = "controller.metrics.enabled"
            value = "true"
          },
          {
            name  = "controller.podAnnotations.prometheus\\.io/scrape"
            value = "true"
          },
          {
            name  = "controller.podAnnotations.prometheus\\.io/port"
            value = "10254"
          }
        ]
        
        tags = {
          Name = "ingress-nginx-controller"
        }
      }
      
      # Configuración de AWS for FluentBit
      # aws_for_fluentbit = {
      #   chart_version = "0.1.32"
      #   namespace     = "amazon-cloudwatch"
        
      #   set = [
      #     {
      #       name  = "cloudWatchLogs.region"
      #       value = "us-east-1"
      #     },
      #     {
      #       name  = "cloudWatchLogs.logGroupName"
      #       value = "/aws/eks/arquitectura-avanzada/cluster"
      #     },
      #     {
      #       name  = "cloudWatchLogs.logStreamName"
      #       value = "fluentbit"
      #     },
      #     {
      #       name  = "cloudWatchLogs.autoCreateGroup"
      #       value = "true"
      #     }
      #   ]
        
      #   tags = {
      #     Name = "aws-for-fluentbit"
      #   }
      # }
      
      # Configuración de CloudWatch Log Group para FluentBit
      # aws_for_fluentbit_cw_log_group = {
      #   name              = "/aws/eks/arquitectura-avanzada/cluster"
      #   retention_in_days = 7  # 7 días para desarrollo
      #   kms_key_id        = null
        
      #   tags = {
      #     Name        = "eks-cluster-logs"
      #     Environment = "dev"
      #     Service     = "EKS"
      #   }
      # }
      
      # Configuración del Metrics Server
      # metrics_server = {
      #   chart_version = "3.12.1"
      #   namespace     = "kube-system"
        
      #   set = [
      #     {
      #       name  = "metrics.enabled"
      #       value = "true"
      #     },
      #     {
      #       name  = "serviceMonitor.enabled"
      #       value = "true"
      #     }
      #   ]
        
      #   tags = {
      #     Name = "metrics-server"
      #   }
      # }
      
      # Configuración de Secrets Store CSI Driver
      secrets_store_csi_driver = {
        chart_version = "1.4.4"
        namespace     = "kube-system"
        
        set = [
          {
            name  = "syncSecret.enabled"
            value = "true"
          },
          {
            name  = "enableSecretRotation"
            value = "true"
          }
        ]
        
        tags = {
          Name = "secrets-store-csi-driver"
        }
      }
      
      # Configuración de AWS Secrets Store CSI Driver Provider
      secrets_store_csi_driver_provider_aws = {
        chart_version = "0.3.4"
        namespace     = "kube-system"
        
        tags = {
          Name = "secrets-store-csi-driver-provider-aws"
        }
      }
      
      # ARNs para External Secrets (acceso a Secrets Manager)
      external_secrets_secrets_manager_arns = [
        "arn:aws:secretsmanager:us-east-1:476114125818:secret:*"
      ]
      
      external_secrets_kms_key_arns = [
        "arn:aws:kms:us-east-1:476114125818:key/*"
      ]

      # Kube Prometheus Stack
      enable_kube_prometheus_stack = true
      kube_prometheus_stack = {
        chart_version = "51.9.0"
        namespace     = "monitoring"
        create_namespace = true
        set = [
          {
            name  = "grafana.enabled"
            value = "true"
          },
          {
            name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
            value = "false"
          },
          {
            name  = "grafana.grafana.ini.server.root_url"
            value = "%(protocol)s://%(domain)s:%(http_port)s/grafana"
          },
          {
            name  = "grafana.grafana.ini.server.serve_from_sub_path"
            value = "true"
          }
        ]
      }
      
      # Tags para todos los recursos
      tags = {
        Terraform   = "true"
        Environment = "dev"
        Project     = "arquitectura-avanzada-udea"
        Owner       = "devops-team"
        CostCenter  = "development"
        Layer       = "Container"
        Service     = "EKS-Addons"
        Purpose     = "Kubernetes Addons"
      }
    }
    
    dev = {
      # Configuraciones específicas para desarrollo
    }
    
    prod = {
    }
  }
  
  # Lógica para seleccionar el ambiente
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}
