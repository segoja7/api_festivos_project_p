# 🧪 Guía de Pruebas y Validación de API

## 📋 Información General

### **URL Base de la API:**
```
<DNS BALANCEADOR>
```
> ⚠️ **NOTA:** Esta URL cambiará cada vez que se recree la infraestructura.

### **Arquitectura Desplegada:**
- **EKS Cluster** con 2 pods activos
- **Application Load Balancer (ALB)** para balanceo de carga
- **Spring Boot**

---

## 🔄 Pasos de Despliegue y Verificación

### **Paso 1: Verificar Estado de la Infraestructura**
```bash
# Verificar que el cluster EKS esté activo y los pods corriendo
kubectl get nodes
kubectl get pods -n festivos-api
```

### **Paso 2: Obtener URL del Balanceador**
```bash
# Obtener la nueva URL del ALB
kubectl get ingress -n festivos-api festivos-api-ingress-alb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
> **NOTA:** Deberás usar esta URL en todos los comandos de prueba.

---

## 🚀 Endpoints y Comandos de Prueba (cURL)

A continuación se listan los endpoints disponibles y los comandos `curl` para probarlos. Reemplaza `<ALB_URL>` con la URL obtenida en el paso anterior.

### **🌍 Gestión de Países**
```bash
# Listar Todos los Países
curl "http://<ALB_URL>/api/paises/listar"

# Obtener País por ID (ej: 1)
curl "http://<ALB_URL>/api/paises/obtener/1"

# Buscar País por Nombre (ej: Colombia)
curl "http://<ALB_URL>/api/paises/buscar/Colombia"

# Crear Nuevo País (ej: Brasil)
curl -X POST -H "Content-Type: application/json" -d '{"nombre": "Brasil"}' "http://<ALB_URL>/api/paises/agregar"

# Modificar País (ej: id 1)
curl -X PUT -H "Content-Type: application/json" -d '{"id": 1, "nombre": "Colombia"}' "http://<ALB_URL>/api/paises/modificar"

# Eliminar País (ej: id 3)
curl -X DELETE "http://<ALB_URL>/api/paises/eliminar/3"
```

### **🎉 Gestión de Festivos**
```bash
# Listar Todos los Festivos
curl "http://<ALB_URL>/api/festivos/listar"

# Obtener Festivo por ID (ej: 1)
curl "http://<ALB_URL>/api/festivos/obtener/1"

# Listar Festivos por País y Año (ej: Colombia, 2024)
curl "http://<ALB_URL>/api/festivos/listar/1/2024"

# Verificar Fecha Festiva (ej: 1 de Enero de 2024 en Colombia)
curl "http://<ALB_URL>/api/festivos/verificar/1/2024/1/1"
```

### **📋 Gestión de Tipos**
```bash
# Listar Todos los Tipos
curl "http://<ALB_URL>/api/tipos/listar"
```

---

## 🔧 Configuración de Postman

1.  **Crear Colección**: "Festivos API"
2.  **Crear Variable de Colección**:
    *   `baseUrl`: `http://<ALB_URL>` (actualizar después de cada despliegue)
3.  **Crear Peticiones**:
    *   **Listar Países**:
        *   **Method**: `GET`
        *   **URL**: `{{baseUrl}}/api/paises/listar`

---

## 🐛 Troubleshooting

### **Error de Conexión**
-   **Causa:** ALB no disponible o URL incorrecta.
-   **Verificación:**
    ```bash
    kubectl get ingress -n festivos-api
    kubectl get pods -n festivos-api -l app=festivos-api
    ```

### **URL Cambiada**
-   **Causa:** Infraestructura recreada.
-   **Solución:** Obtener la nueva URL con el comando del **Paso 2**.

---

## 📈 Monitoreo y Logs

### **Verificar Estado de la Aplicación**
```bash
# Estado de pods
kubectl get pods -n festivos-api -l app=festivos-api

# Logs de aplicación
kubectl logs -n festivos-api -l app=festivos-api --tail=100

# Estado del Ingress
kubectl get ingress -n festivos-api
```
