apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: aws-secrets-manager
  namespace: ${NAMESPACE}
spec:
  provider:
    aws:
      service: SecretsManager
      region: ${AWS_REGION}
      auth:
        # Using IRSA (IAM Roles for Service Accounts)
        jwt:
          serviceAccountRef:
            name: external-secrets-sa
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: rds-credentials
  namespace: ${NAMESPACE}
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: SecretStore
  target:
    name: rds-secret
    creationPolicy: Owner
    template:
      type: Opaque
      data:
        # Spring Boot database configuration
<<<<<<< HEAD:k8s/manifests/external-secret.yaml
        SPRING_DATASOURCE_URL: "jdbc:postgresql://arquitectura-avanzada-postgres.co7s806uqdld.us-east-1.rds.amazonaws.com:5432/arquitectura_db"
=======
        SPRING_DATASOURCE_URL: "jdbc:postgresql://${RDS_ENDPOINT}:${DB_PORT}/${DB_NAME}"
>>>>>>> new_code_app:k8s/templates/external-secret.yaml.tpl
        SPRING_DATASOURCE_USERNAME: "{{ .username }}"
        SPRING_DATASOURCE_PASSWORD: "{{ .password }}"
        SPRING_DATASOURCE_DRIVER_CLASS_NAME: "org.postgresql.Driver"
        # Individual values for flexibility
<<<<<<< HEAD:k8s/manifests/external-secret.yaml
        DB_HOST: "arquitectura-avanzada-postgres.co7s806uqdld.us-east-1.rds.amazonaws.com"
        DB_PORT: "5432"
        DB_NAME: "arquitectura_db"
=======
        DB_HOST: "${RDS_ENDPOINT}"
        DB_PORT: "${DB_PORT}"
        DB_NAME: "${DB_NAME}"
>>>>>>> new_code_app:k8s/templates/external-secret.yaml.tpl
        DB_USERNAME: "{{ .username }}"
        DB_PASSWORD: "{{ .password }}"
  data:
  - secretKey: username
    remoteRef:
      key: ${RDS_SECRET_ARN}
      property: username
  - secretKey: password
    remoteRef:
      key: ${RDS_SECRET_ARN}
      property: password
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: jwt-secrets
  namespace: ${NAMESPACE}
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: SecretStore
  target:
    name: jwt-secret
    creationPolicy: Owner
    template:
      type: Opaque
      data:
        # JWT Secret for Spring Boot application
        JWT_SECRET: "{{ .jwt_secret }}"
  data:
  - secretKey: jwt_secret
    remoteRef:
      key: ${JWT_SECRET_ARN}
      property: jwt_secret
