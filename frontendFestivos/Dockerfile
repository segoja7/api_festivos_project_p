# Multi-stage build para optimizar el tamaño de la imagen
FROM node:18-alpine AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar código fuente
COPY . .

# Construir la aplicación para producción
RUN npm run build

# Etapa de producción con servidor HTTP simple
FROM node:18-alpine

# Instalar http-server globalmente
RUN npm install -g http-server

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos construidos desde la etapa anterior (desde browser donde está el index.html)
COPY --from=build /app/dist/browser ./dist

# Exponer puerto 8080 (puerto por defecto de http-server)
EXPOSE 8080

# Comando para servir la aplicación
# -p 8080: puerto
# -a 0.0.0.0: escuchar en todas las interfaces
# --cors: habilitar CORS para la API
# -d false: deshabilitar listado de directorios
# --gzip: habilitar compresión gzip
CMD ["http-server", "dist", "-p", "8080", "-a", "0.0.0.0", "--cors", "-d", "false", "--gzip"]
