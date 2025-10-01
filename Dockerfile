# ----------------------------------------------------------------------
# ETAPA 1: BUILD (Compilação) - Gera os arquivos estáticos
# ----------------------------------------------------------------------
FROM node:20-alpine AS build

WORKDIR /app

# Copia dependências e instala
COPY package*.json ./
RUN npm install

# Copia o código e compila
COPY . .
# Este comando cria a pasta 'build'
RUN npm run build 


# ----------------------------------------------------------------------
# ETAPA 2: PRODUÇÃO (Serviço) - Serve os arquivos compilados via Nginx
# ----------------------------------------------------------------------
FROM nginx:alpine AS final

# Copia os arquivos estáticos da pasta 'build' (Etapa 1) para o Nginx
COPY --from=build /app/build /usr/share/nginx/html

# A porta padrão do Nginx que será acessada pelo Traefik
EXPOSE 80

# Comando para iniciar o servidor Nginx
CMD ["nginx", "-g", "daemon off;"]
