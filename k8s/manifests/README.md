# 📁 Kubernetes Manifests - Arquitectura Avanzada 

## 📋 Archivos del Proyecto

Esta carpeta contiene **únicamente** los manifests necesarios para el despliegue de la aplicación de festivos en AWS EKS.

### 🚀 **Manifests de Aplicación**

#### **1. `deployment.yaml`**
- **Propósito:** Deployment principal de la aplicación Spring Boot
- **Características:**
  - 2 réplicas para alta disponibilidad
  - Configuración de variables de entorno desde External Secrets
  - TCP probes para liveness y readiness
  - Configuración de recursos (CPU/memoria)

#### **2. `service.yaml`**
- **Propósito:** Service ClusterIP para exponer la aplicación internamente
- **Características:**
  - Expone puerto 80 que mapea al 8080 del contenedor
  - Selector para pods de la aplicación
  - Load balancing entre réplicas

#### **3. `ingress-alb.yaml`**
- **Propósito:** Ingress con AWS Application Load Balancer
- **Características:**
  - Usa AWS Load Balancer Controller
  - Configuración de health checks
  - Tags para identificación
  - Expone la aplicación al exterior

### 🔐 **Manifests de Seguridad**

#### **4. `external-secret.yaml`**
- **Propósito:** External Secret para sincronizar secretos desde AWS Secrets Manager
- **Características:**
  - Sincroniza credenciales de RDS PostgreSQL
  - Sincroniza JWT secret para autenticación
  - Actualización automática cada 15 segundos

#### **5. `external-secrets-serviceaccount.yaml`**
- **Propósito:** ServiceAccount con permisos para External Secrets Operator
- **Características:**
  - Anotaciones para IRSA (IAM Roles for Service Accounts)
  - Permisos para acceder a AWS Secrets Manager

### 🗄️ **Manifests de Base de Datos**

#### **6. `sql-scripts-original.yaml`**
- **Propósito:** ConfigMap con scripts SQL originales para poblar la base de datos
- **Características:**
  - Scripts DDL para crear tablas
  - Scripts DML para insertar datos de festivos
  - Datos de Colombia y Ecuador

#### **7. `db-complete-setup.yaml`**
- **Propósito:** Job para configuración completa de la base de datos
- **Características:**
  - Limpia y recrea tablas
  - Ejecuta scripts SQL originales
  - Verifica datos insertados
  - Se ejecuta una sola vez

---

## 🔄 Orden de Aplicación

### **Despliegue Inicial:**
```bash
# 1. Configurar External Secrets
kubectl apply -f external-secrets-serviceaccount.yaml
kubectl apply -f external-secret.yaml

# 2. Poblar base de datos
kubectl apply -f sql-scripts-original.yaml
kubectl apply -f db-complete-setup.yaml

# 3. Desplegar aplicación
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress-alb.yaml
```

### **Verificación:**
```bash
# Verificar que todos los recursos estén creados
kubectl get all -n external-secrets-system -l app=festivos-api
kubectl get ingress -n external-secrets-system
kubectl get externalsecret -n external-secrets-system
```

---

## 📝 Notas Importantes

### **Variables que Cambiarán:**
- **Imagen del contenedor** en `deployment.yaml` - Actualizar con nueva versión
- **URL del ALB** en `ingress-alb.yaml` - Se genera automáticamente
- **ARN del rol IAM** en `external-secrets-serviceaccount.yaml` - Específico del entorno

### **Configuración de Entorno:**
- Todos los manifests están configurados para el namespace `external-secrets-system`
- La aplicación usa External Secrets para obtener credenciales
- El ALB se crea automáticamente con el AWS Load Balancer Controller

### **Dependencias:**
- **External Secrets Operator** debe estar instalado en el cluster
- **AWS Load Balancer Controller** debe estar instalado y configurado
- **RDS PostgreSQL** debe estar creado y accesible
- **AWS Secrets Manager** debe contener los secretos necesarios

---

## 🧹 Archivos Eliminados

Los siguientes archivos fueron eliminados por ser innecesarios o obsoletos:

- `namespace.yaml` - No necesario, usamos external-secrets-system existente
- `configmap.yaml` - ConfigMap genérico no utilizado
- `secret.yaml` - Secreto manual, reemplazado por External Secrets
- `init-db-configmap.yaml` - ConfigMap obsoleto
- `init-db.sql` - Script SQL suelto, incluido en ConfigMap
- `sql-scripts-configmap.yaml` - ConfigMap duplicado
- `db-init-job.yaml` - Job obsoleto
- `db-final-job.yaml` - Job de prueba temporal
- `db-original-job.yaml` - Job obsoleto
- `db-clean-job.yaml` - Job de limpieza temporal
- `check-tables-job.yaml` - Job de verificación temporal
- `ingress.yaml` - Ingress con NGINX (no utilizado)
- `ingress-aws.yaml` - Ingress incompleto

---

## 🔧 Troubleshooting

### **Si falta algún archivo:**
```bash
# Verificar que todos los archivos necesarios estén presentes
ls -la *.yaml
```

### **Si el deployment falla:**
```bash
# Verificar logs del deployment
kubectl logs -n external-secrets-system -l app=festivos-api

# Verificar External Secrets
kubectl get externalsecret -n external-secrets-system
kubectl describe externalsecret -n external-secrets-system
```

### **Si el ALB no se crea:**
```bash
# Verificar AWS Load Balancer Controller
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

---

**Última actualización:** $(date)  
**Archivos totales:** 7  
**Estado:** Limpio y optimizado
