# Festivos API - Despliegue en AWS con EKS y Terragrunt

Este proyecto despliega una API de festivos desarrollada en Java Spring Boot con arquitectura hexagonal en un cluster de Amazon EKS, utilizando Terragrunt para la gestión de infraestructura como código, con una base de datos PostgreSQL en Amazon RDS y un pipeline CI/CD completo usando CodePipeline y CodeBuild.

## Arquitectura

- **Aplicación**: Java Spring Boot 3.5.0 con arquitectura hexagonal modular
- **Base de datos**: PostgreSQL en Amazon RDS con AWS Secrets Manager
- **Contenedores**: Docker images almacenadas en Amazon ECR
- **Orquestación**: Amazon EKS (Kubernetes) con Application Load Balancer
- **IaC**: Terragrunt para gestión modular de infraestructura
- **CI/CD**: AWS CodePipeline + CodeBuild
- **Secretos**: AWS Secrets Manager + External Secrets Operator
- **Load Balancer**: AWS Load Balancer Controller (ALB)
- **VPC**: VPC personalizada con VPC Endpoints para ECR

## Prerrequisitos

1. **AWS CLI** configurado con perfil `udea` y permisos administrativos
2. **Terragrunt** >= 0.50.0
3. **Terraform** >= 1.0
4. **kubectl** para interactuar con Kubernetes
5. **Docker Hub credentials** para acceso a imágenes base
6. **Java 17** y **Maven** para desarrollo local

## Estructura del Proyecto

```
api_festivos_project/
├── terragrunt/                    # Infraestructura como código con Terragrunt
│   ├── terragrunt.hcl            # Configuración raíz de Terragrunt
│   ├── common/                   # Configuraciones comunes
│   │   └── additional_providers/ # Proveedores adicionales (K8s, Helm)
│   └── resources/                # Módulos de recursos
│       ├── network/              # VPC, Security Groups, VPC Endpoints
│       ├── containers/           # EKS, ECR, Addons
│       ├── databases/            # RDS PostgreSQL
│       ├── security/             # Secrets Manager
│       ├── ci-cd/                # CodePipeline y CodeBuild
│       └── templates/            # Plantillas reutilizables
├── TT_ANI_apiFestivos/           # Código fuente de la aplicación
│   ├── dominio/                  # Capa de dominio
│   ├── core/                     # Lógica de negocio
│   ├── aplicacion/               # Casos de uso
│   ├── infraestructura/          # Adaptadores de infraestructura
│   ├── presentacion/             # Controladores REST
│   ├── pom.xml                   # Configuración Maven multi-módulo
│   └── Dockerfile                # Imagen Docker de la aplicación
├── k8s/                          # Manifiestos de Kubernetes
│   └── manifests/                # Deployments, Services, Ingress, etc.
├── bd/                           # Scripts de base de datos
│   └── festivos/                 # DDL y DML para festivos
├── API_TESTING_GUIDE.md          # Guía de pruebas de la API
└── README.md                     # Este archivo
```

## Configuración del Entorno

### 1. Configurar Variables de Entorno

El proyecto utiliza el workspace `dev` por defecto. Puedes cambiar el entorno configurando:

```bash
export TERRAGRUNT_WORKSPACE=dev  # o prod, staging, etc.
terragrunt run -all workspace select dev
```

### 2. Configurar AWS Profile

Asegúrate de tener configurado el perfil AWS `udea`:

```bash
aws configure --profile udea
# Configura: Access Key ID, Secret Access Key, Region (us-east-1)
```

## Despliegue de Infraestructura

### 1. Desplegar Toda la Infraestructura

```bash
cd terragrunt/resources

# Desplegar todos los módulos en orden de dependencias
terragrunt run-all apply
```

### 2. Desplegar Módulos Específicos

```bash
# Desplegar solo la VPC
cd terragrunt/resources/network/vpc
terragrunt apply

# Desplegar solo el cluster EKS
cd terragrunt/resources/containers/eks_cluster
terragrunt apply

# Desplegar solo RDS
cd terragrunt/resources/databases/rds/postgre
terragrunt apply

# Desplegar pipeline CI/CD
cd terragrunt/resources/ci-cd/codepipeline
terragrunt apply
```

### 3. Verificar Despliegue

```bash
# Configurar kubectl
aws eks --region us-east-1 update-kubeconfig --name <cluster-name> --profile udea

# Verificar nodos del cluster
kubectl get nodes

# Verificar pods de la aplicación
kubectl get pods -n festivos-api

# Verificar servicios
kubectl get svc -n festivos-api

# Verificar ingress y obtener URL del ALB
kubectl get ingress -n festivos-api
```

## Componentes de la Infraestructura

### Red (Network)
- **VPC**: VPC personalizada con subnets públicas y privadas
- **Security Groups**: Grupos de seguridad para EKS, RDS y ALB
- **VPC Endpoints**: Endpoints para ECR (API y DKR) para acceso privado

### Contenedores (Containers)
- **EKS Cluster**: Cluster Kubernetes gestionado con node groups
- **ECR Repository**: Repositorio privado para imágenes Docker
- **EKS Addons**: AWS Load Balancer Controller y otros addons

### Base de Datos (Databases)
- **RDS PostgreSQL**: Instancia de base de datos con backup automático
- **Secrets Manager**: Credenciales de base de datos gestionadas automáticamente

### Seguridad (Security)
- **Secrets Manager**: Gestión de secretos (JWT, DockerHub, RDS)
- **External Secrets Operator**: Sincronización de secretos en Kubernetes

### CI/CD
- **CodePipeline**: Pipeline de despliegue automático
- **CodeBuild**: Construcción y despliegue de la aplicación
- **GitHub Integration**: Integración con repositorio de código

## Aplicación Java

### Arquitectura Hexagonal

La aplicación sigue el patrón de arquitectura hexagonal con los siguientes módulos:

- **dominio**: Entidades y reglas de negocio
- **core**: Lógica de negocio central
- **aplicacion**: Casos de uso y servicios de aplicación
- **infraestructura**: Adaptadores para base de datos y servicios externos
- **presentacion**: Controladores REST y DTOs

### Endpoints Disponibles

Consulta el archivo `API_TESTING_GUIDE.md` para obtener la lista completa de endpoints y ejemplos de uso.

### Tecnologías Utilizadas

- **Spring Boot 3.5.0**
- **Spring Data JPA**
- **Spring Web**
- **Spring Actuator**
- **PostgreSQL Driver**
- **Java 17**
- **Maven** (multi-módulo)

## Base de Datos

### Estructura

- **Tabla países**: Gestión de países
- **Tabla tipos**: Tipos de festivos
- **Tabla festivos**: Festivos por país y año

### Scripts

- `bd/festivos/DDL - Festivos.sql`: Estructura de tablas
- `bd/festivos/DML - Festivos.sql`: Datos iniciales

## Pipeline CI/CD

### Flujo de Despliegue

1. **Source**: Código desde GitHub
2. **Build**: 
   - Compilación con Maven
   - Construcción de imagen Docker
   - Push a ECR
3. **Deploy**:
   - Actualización de manifiestos Kubernetes
   - Despliegue en EKS
   - Verificación de salud

### Configuración de Secretos

Los siguientes secretos deben estar configurados en AWS Secrets Manager:

- **JWT Secret**: Para autenticación de la aplicación
- **DockerHub Credentials**: Para acceso a imágenes base
- **RDS Credentials**: Gestionadas automáticamente por RDS

## Monitoreo y Logs

### CloudWatch

- **EKS Control Plane Logs**: Logs del plano de control de Kubernetes
- **Application Logs**: Logs de la aplicación Spring Boot
- **RDS Logs**: Logs de la base de datos PostgreSQL

### Kubernetes

```bash
# Ver logs de la aplicación
kubectl logs -f deployment/festivos-api -n festivos-api

# Ver eventos del namespace
kubectl get events -n festivos-api --sort-by='.lastTimestamp'

# Verificar estado de pods
kubectl get pods -n festivos-api -o wide

# Verificar External Secrets
kubectl get externalsecrets -n festivos-api
```

## Comandos Útiles

### Terragrunt

```bash
# Ver plan de todos los módulos
terragrunt run-all plan

# Aplicar cambios a todos los módulos
terragrunt run-all apply

# Destruir toda la infraestructura
terragrunt run-all destroy

# Ver outputs de un módulo específico
cd terragrunt/resources/containers/eks_cluster
terragrunt output
```

### Kubernetes

```bash
# Obtener URL del Load Balancer
kubectl get ingress -n festivos-api -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'

# Reiniciar deployment
kubectl rollout restart deployment/festivos-api -n festivos-api

# Escalar aplicación
kubectl scale deployment/festivos-api --replicas=3 -n festivos-api

# Port forward para pruebas locales
kubectl port-forward svc/festivos-api-service 8080:80 -n festivos-api
```

## Troubleshooting

### Problemas Comunes

1. **Error de permisos de Terragrunt**:
   - Verifica que el perfil AWS `udea` esté configurado correctamente
   - Asegúrate de tener permisos administrativos

2. **Pods no inician**:
   - Verifica que External Secrets Operator esté funcionando
   - Revisa los logs: `kubectl logs -n festivos-api <pod-name>`

3. **No se puede acceder a la aplicación**:
   - Verifica que el ALB esté creado: `kubectl get ingress -n festivos-api`
   - Revisa los security groups del ALB

4. **Error de conexión a RDS**:
   - Verifica que los secretos estén sincronizados
   - Revisa la conectividad de red entre EKS y RDS

### Logs y Diagnóstico

```bash
# Logs del External Secrets Operator
kubectl logs -n external-secrets-system deployment/external-secrets

# Logs del AWS Load Balancer Controller
kubectl logs -n kube-system deployment/aws-load-balancer-controller

# Describir recursos problemáticos
kubectl describe pod <pod-name> -n festivos-api
kubectl describe externalsecret <secret-name> -n festivos-api
```

## Limpieza

### Eliminar Aplicación

```bash
# Eliminar recursos de Kubernetes
kubectl delete namespace festivos-api
```

### Eliminar Infraestructura

```bash
cd terragrunt/resources

# Eliminar toda la infraestructura
terragrunt run-all destroy
```

**Nota**: El orden de eliminación es importante. Terragrunt manejará las dependencias automáticamente.

## Seguridad

- **Secretos**: Todos los secretos están en AWS Secrets Manager
- **Red**: VPC privada con VPC Endpoints para servicios AWS
- **Acceso**: EKS con autenticación IAM y RBAC
- **Encriptación**: Datos en tránsito y en reposo encriptados
- **Imágenes**: Escaneo de vulnerabilidades en ECR

## Costos

### Optimización

- **EKS**: Usa instancias t3.medium para nodos (desarrollo)
- **RDS**: Instancia db.t3.micro para desarrollo
- **VPC Endpoints**: Solo los necesarios (ECR)
- **CloudWatch**: Retención de logs configurada a 7 días

### Estimación Mensual (Desarrollo)

- **EKS Cluster**: ~$73/mes
- **EC2 Instances** (2x t3.medium): ~$60/mes
- **RDS** (db.t3.micro): ~$15/mes
- **ALB**: ~$20/mes
- **VPC Endpoints**: ~$15/mes
- **Total Estimado**: ~$183/mes

## Soporte

Para problemas o preguntas:

1. **Logs**: Revisa CloudWatch y kubectl logs
2. **Estado**: Verifica el estado de recursos con kubectl y AWS Console
3. **Documentación**: Consulta `API_TESTING_GUIDE.md` para pruebas
4. **Terragrunt**: Usa `terragrunt run-all plan` para verificar cambios

## Próximos Pasos

- [ ] Implementar Horizontal Pod Autoscaler (HPA)
- [ ] Configurar Cluster Autoscaler
- [ ] Añadir métricas con Prometheus/Grafana
- [ ] Implementar backup automático de RDS
- [ ] Configurar alertas en CloudWatch
- [ ] Añadir tests de integración al pipeline
