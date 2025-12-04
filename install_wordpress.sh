#!/bin/bash

# Création du dossier wordpress
mkdir -p wordpress
cd wordpress

# Création du fichier docker-compose.yml
cat <<EOF > docker-compose.yml
version: "3"
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: Pssword
      MYSQL_DATABASE: MySQLDatabaseName
      MYSQL_USER: MySQL
      MYSQL_PASSWORD: Password
    volumes:
      - db:/var/lib/mysql

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: MySQL
      WORDPRESS_DB_PASSWORD: Password
      WORDPRESS_DB_NAME: MySQLDatabaseName
    volumes:
      - wordpress:/var/www/html

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
      - "8081:80"
    environment:
      PMA_HOST: db
      PMA_USER: MySQL
      PMA_PASSWORD: Password

volumes:
  wordpress:
  db:
EOF

# Lancement du docker compose
docker compose up -d
