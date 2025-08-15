apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${APP_NAME}-app-ingress-alb
  namespace: ${NAMESPACE}
  annotations:
    # IMPORTANTE: Usar AWS Load Balancer Controller para ALB
    kubernetes.io/ingress.class: alb
    # Configuración específica para ALB (NO Classic Load Balancer)
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/load-balancer-name: ${APP_NAME}-app-alb
    alb.ingress.kubernetes.io/group.name: ${APP_NAME}-app-group
    
    # Configuraciones de salud para ALB
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '30'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '3'
    
    # Configuraciones de timeout para ALB
    alb.ingress.kubernetes.io/load-balancer-attributes: |
      idle_timeout.timeout_seconds=60,
      routing.http2.enabled=true,
      access_logs.s3.enabled=false
    
    # Configuraciones de listener
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
    
    # Tags para el ALB
    alb.ingress.kubernetes.io/tags: |
      Environment=${ENVIRONMENT},
      Project=${PROJECT_NAME},
      Service=${APP_NAME}-app
spec:
  ingressClassName: alb
  rules:
  - http:
      paths:
      # Ruta para la API - debe ir ANTES que la ruta del frontend
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: ${APP_NAME}-api-service
            port:
              number: 80
      # Ruta para el frontend - debe ir DESPUÉS de las rutas específicas
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ${APP_NAME}-frontend-service
            port:
              number: 80
