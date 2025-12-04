#!/bin/bash

mkdir -p /opt/zabbix && cd /opt/zabbix

cat > docker-compose.yml << 'EOF'
version: "3.8"
services:
  mysql:
    image: mysql:8.0
    container_name: zabbix-mysql
    environment:
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - zabbix-mysql:/var/lib/mysql
    restart: unless-stopped

  zabbix-server:
    image: zabbix/zabbix-server-mysql:ubuntu-7.0-latest
    container_name: zabbix-server
    environment:
      DB_SERVER_HOST: mysql
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix
    depends_on:
      - mysql
    ports:
      - "10051:10051"
    restart: unless-stopped

  zabbix-web:
    image: zabbix/zabbix-web-nginx-mysql:ubuntu-7.0-latest
    container_name: zabbix-web
    environment:
      DB_SERVER_HOST: mysql
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix
      ZBX_SERVER_HOST: zabbix-server
      PHP_TZ: Europe/Paris
    depends_on:
      - mysql
      - zabbix-server
    ports:
      - "8080:8080"
    restart: unless-stopped

volumes:
  zabbix-mysql:
EOF

docker compose down -v 2>/dev/null || true
docker compose up -d
