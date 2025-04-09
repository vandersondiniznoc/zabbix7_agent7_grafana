# Zabbix + Grafana Stack (Docker)
Instalação completa do Zabbix 7.0 LTS + Agent e Grafana usando Docker Compose.

## ✅ Funcionalidades
- Zabbix Server 7.0 LTS
- Zabbix Agent 7.0
- Frontend Web NGINX
- Banco de dados MySQL 8.0
- Grafana (última versão)

## 🚀 Instalação

```bash
cd /home/
mkdir docker
cd /home/docker/
git clone https://github.com/vandersondiniznoc/zabbix7_agent7_grafana.git
cd zabbix7_agent7_grafana/
chmod +x install.sh
./install.sh

Liste os contêiners em execução com o comando:
docker ps -a

Acesse o contêiner que está rodando o Zabbix Agent:
docker exec -it zabbix-docker-zabbix-agent-1 bash

Altere o IP do Zabbix Agent na interface WEB 
