---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}-frontend
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}-frontend
spec:
  replicas: ${FRONTEND_REPLICAS}
  selector:
    matchLabels:
      app: ${APP_NAME}-frontend
  template:
    metadata:
      labels:
        app: ${APP_NAME}-frontend
    spec:
      containers:
      - name: ${APP_NAME}-frontend
        image: ${ECR_REPOSITORY_URI}:${FRONTEND_IMAGE_TAG}
        ports:
        - containerPort: 8080
          name: http
        resources:
          requests:
            memory: "${FRONTEND_MEMORY_REQUEST}"
            cpu: "${FRONTEND_CPU_REQUEST}"
          limits:
            memory: "${FRONTEND_MEMORY_LIMIT}"
            cpu: "${FRONTEND_CPU_LIMIT}"

---
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-frontend-service
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}-frontend
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: ${APP_NAME}-frontend
