apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}-api
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}-api
    version: v1
spec:
  replicas: ${API_REPLICAS}
  selector:
    matchLabels:
      app: ${APP_NAME}-api
      version: v1
  template:
    metadata:
      labels:
        app: ${APP_NAME}-api
        version: v1
    spec:
      containers:
      - name: ${APP_NAME}-api
        image: ${ECR_REPOSITORY_URI}:${API_IMAGE_TAG}
        ports:
        - containerPort: 8080
          name: http
        env:
        # Spring Boot configuration
        - name: SPRING_PROFILES_ACTIVE
          value: "${ENVIRONMENT}"
        - name: SERVER_PORT
          value: "8080"
        
        # Database configuration from External Secrets (RDS)
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: rds-secret
              key: SPRING_DATASOURCE_URL
        - name: SPRING_DATASOURCE_USERNAME
          valueFrom:
            secretKeyRef:
              name: rds-secret
              key: SPRING_DATASOURCE_USERNAME
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: rds-secret
              key: SPRING_DATASOURCE_PASSWORD
        - name: SPRING_DATASOURCE_DRIVER_CLASS_NAME
          valueFrom:
            secretKeyRef:
              name: rds-secret
              key: SPRING_DATASOURCE_DRIVER_CLASS_NAME
        
        # JWT Secret from External Secrets
        - name: JWT_SECRET
          valueFrom:
            secretKeyRef:
              name: jwt-secret
              key: JWT_SECRET
        
        # JPA/Hibernate configuration
        - name: SPRING_JPA_HIBERNATE_DDL_AUTO
          value: "validate"
        - name: SPRING_JPA_SHOW_SQL
          value: "false"
        - name: SPRING_JPA_DATABASE_PLATFORM
          value: "org.hibernate.dialect.PostgreSQLDialect"
        
        # Actuator configuration
        - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
          value: "health,info,metrics"
        - name: MANAGEMENT_ENDPOINT_HEALTH_SHOW_DETAILS
          value: "always"
        
        resources:
          requests:
            memory: "${API_MEMORY_REQUEST}"
            cpu: "${API_CPU_REQUEST}"
          limits:
            memory: "${API_MEMORY_LIMIT}"
            cpu: "${API_CPU_LIMIT}"
        # Usar TCP probe para liveness - más simple y confiable
        livenessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 120
          periodSeconds: 30
          timeoutSeconds: 5
          failureThreshold: 3
        # Usar TCP probe para readiness - evita problemas con Spring Security
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 90
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
