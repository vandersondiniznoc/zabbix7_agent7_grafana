#!/bin/bash

set -e

echo "📁 Criando diretório do Zabbix..."
mkdir -p zabbix-docker && cd zabbix-docker

echo "📄 Gerando .env..."
cat <<EOF > .env
POSTGRES_USER=zabbix
POSTGRES_PASSWORD=zabbixpass
POSTGRES_DB=zabbix
ZBX_SERVER_NAME=Zabbix Docker 7
ZBX_DB_USER=zabbix
ZBX_DB_PASSWORD=zabbixpass
ZBX_DB_NAME=zabbix
ZBX_TIMEZONE=America/Sao_Paulo
EOF

echo "📄 Gerando docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3.5'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: \${POSTGRES_USER}
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
      POSTGRES_DB: \${POSTGRES_DB}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

  zabbix-server:
    image: zabbix/zabbix-server-pgsql:alpine-7.0-latest
    depends_on:
      - postgres
    environment:
      DB_SERVER_HOST: postgres
      POSTGRES_USER: \${ZBX_DB_USER}
      POSTGRES_PASSWORD: \${ZBX_DB_PASSWORD}
      POSTGRES_DB: \${ZBX_DB_NAME}
    ports:
      - "10051:10051"
    restart: unless-stopped

  zabbix-web:
    image: zabbix/zabbix-web-nginx-pgsql:alpine-7.0-latest
    depends_on:
      - zabbix-server
      - postgres
    environment:
      DB_SERVER_HOST: postgres
      POSTGRES_USER: \${ZBX_DB_USER}
      POSTGRES_PASSWORD: \${ZBX_DB_PASSWORD}
      POSTGRES_DB: \${ZBX_DB_NAME}
      ZBX_SERVER_HOST: zabbix-server
      PHP_TZ: \${ZBX_TIMEZONE}
    ports:
      - "8080:8080"
    restart: unless-stopped

  zabbix-agent:
    image: zabbix/zabbix-agent:alpine-7.0-latest
    depends_on:
      - zabbix-server
    environment:
      ZBX_SERVER_HOST: zabbix-server
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: admin
    volumes:
      - grafana-storage:/var/lib/grafana
    restart: unless-stopped

volumes:
  postgres-data:
  grafana-storage:
EOF

echo "🚀 Subindo containers..."
docker compose up -d

echo "✅ Zabbix + Grafana instalados com sucesso!"
echo "🌐 Acesse o Zabbix em http://localhost:8080"
echo "🌐 Acesse o Grafana em http://localhost:3000 (user/pass: admin)"
