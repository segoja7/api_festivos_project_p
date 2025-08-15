apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-api-service
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}-api
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: ${APP_NAME}-api
