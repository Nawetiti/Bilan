# 📋 Scripts Docker Debian 12 - README

Ce dépôt contient trois scripts simples pour installer rapidement un environnement Docker, WordPress, et Zabbix sur une machine Debian 12. Chaque script peut être utilisé indépendamment pour déployer ces services essentiels.

Pour en savoir plus sur l'infrastructure Docker et accéder aux explications détaillées de son fonctionnement, veuillez consulter notre [Doc Docker](https://github.com/Nawetiti/Bilan/blob/main/Docker.md).

## Sommaire

- [install_docker.sh](#install_dockersh)
- [install_wordpress.sh](#install_wordpresssh)
- [install_zabbix.sh](#install_zabbixsh)

---

## install_docker.sh

Installe Docker CE et Docker Compose sur Debian 12.

**Usage** :

```
chmod +x install_docker.sh  
./install_docker.sh
```


---

## install_wordpress.sh

Déploie un site WordPress complet avec MySQL en Docker. Accessible sur le port 8080.

**Usage** :


```
chmod +x install_wordpress.sh  
./install_wordpress.sh
```

---

> [!note] Fonctionnement du script 
> 
> ### 1. Préparation 
> 
> - Il **crée un répertoire** nommé `wordpress` et **s'y positionne**.
>     
> 
> ### 2. Configuration (`docker-compose.yml`) 
> 
> - Le script **génère un fichier de configuration** (`docker-compose.yml`). Ce fichier définit trois services conteneurisés :
>     
>     - **`db` (MySQL)** : La base de données. Il utilise l'image `mysql:latest` et configure les identifiants de connexion ainsi qu'un volume persistant pour les données.
>         
>     - **`wordpress`** : L'application web. Il utilise l'image `wordpress:latest`, dépend du service `db`, et expose le service sur le **port `8080`** de la machine hôte. Il configure également l'accès à la base de données et utilise un volume pour les fichiers du site.
>         
>     - **`phpmyadmin`** : L'interface de gestion de la base de données. Il est configuré pour se connecter au service `db` et est accessible sur le **port `8081`** de la machine hôte.
>         
> 
> ### 3. Exécution 
> 
> - Il exécute la commande **`docker compose up -d`**.
>     
> - Cette commande **télécharge les images** nécessaires et **démarre les trois conteneurs** en arrière-plan.
>   
> ```
> 
> #!/bin/bash
> 
> # Création du dossier wordpress
> mkdir -p wordpress
> cd wordpress
> 
> # Création du fichier docker-compose.yml
> cat <<EOF > docker-compose.yml
> version: "3"
> services:
>   db:
>     image: mysql:latest
>     restart: always
>     environment:
>       MYSQL_ROOT_PASSWORD: Pssword
>       MYSQL_DATABASE: MySQLDatabaseName
>       MYSQL_USER: MySQL
>       MYSQL_PASSWORD: Password
>     volumes:
>       - db:/var/lib/mysql
> 
>   wordpress:
>     depends_on:
>       - db
>     image: wordpress:latest
>     restart: always
>     ports:
>       - "8080:80"
>     environment:
>       WORDPRESS_DB_HOST: db:3306
>       WORDPRESS_DB_USER: MySQL
>       WORDPRESS_DB_PASSWORD: Password
>       WORDPRESS_DB_NAME: MySQLDatabaseName
>     volumes:
>       - wordpress:/var/www/html
> 
>   phpmyadmin:
>     image: phpmyadmin/phpmyadmin
>     restart: always
>     ports:
>       - "8081:80"
>     environment:
>       PMA_HOST: db
>       PMA_USER: MySQL
>       PMA_PASSWORD: Password
> 
> volumes:
>   wordpress:
>   db:
> EOF
> 
> # Lancement du docker compose
> docker compose up -d
> ```
> 


---

## install_zabbix.sh

Installe Zabbix Server et Web avec une base MySQL en Docker. Interface accessible sur le port 8081.

**Usage** :


```
chmod +x install_zabbix.sh  
./install_zabbix.sh
```


> [!note] Fonctionnement du script
> ### 1. Préparation de l'environnement
> 
> - Il **crée le dossier** `/opt/zabbix` (s'il n'existe pas) et **se place** à l'intérieur.
>     
> 
> ### 2. Configuration (`docker-compose.yml`) 📝
> 
> - Il **crée un fichier de configuration** (`docker-compose.yml`) qui définit trois services :
>     
>     - **`mysql`**: Le conteneur de base de données. Il utilise MySQL 8.0 et stocke toutes les données de Zabbix (configuration, historique, etc.).
>         
>     - **`zabbix-server`**: Il expose le port de communication interne Zabbix **`10051`**.
>         
>     - **`zabbix-web`**: L'interface utilisateur web. Ce conteneur (basé sur Nginx et PHP) permet d'accéder à Zabbix via un navigateur. Il est exposé sur le **port `8080`** de la machine hôte.
>     
> 
> ### 3. Exécution et Lancement
> 
> - `docker compose down -v 2>/dev/null || true`: Cette commande tente d'abord d'**arrêter et de supprimer** tout environnement Zabbix précédent (y compris les volumes) pour garantir un nouveau départ propre. L'ajout de `|| true` empêche le script de s'arrêter s'il n'y a rien à supprimer.
>     
> - `docker compose up -d`: Cette commande finale **télécharge les images** et **démarre les trois conteneurs** en arrière-plan.
> 
> 
> 
> ```
> #!/bin/bash
> 
> mkdir -p /opt/zabbix && cd /opt/zabbix
> 
> cat > docker-compose.yml << 'EOF'
> version: "3.8"
> services:
>   mysql:
>     image: mysql:8.0
>     container_name: zabbix-mysql
>     environment:
>       MYSQL_DATABASE: zabbix
>       MYSQL_USER: zabbix
>       MYSQL_PASSWORD: zabbix
>       MYSQL_ROOT_PASSWORD: root
>     volumes:
>       - zabbix-mysql:/var/lib/mysql
>     restart: unless-stopped
> 
>   zabbix-server:
>     image: zabbix/zabbix-server-mysql:ubuntu-7.0-latest
>     container_name: zabbix-server
>     environment:
>       DB_SERVER_HOST: mysql
>       MYSQL_DATABASE: zabbix
>       MYSQL_USER: zabbix
>       MYSQL_PASSWORD: zabbix
>     depends_on:
>       - mysql
>     ports:
>       - "10051:10051"
>     restart: unless-stopped
> 
>   zabbix-web:
>     image: zabbix/zabbix-web-nginx-mysql:ubuntu-7.0-latest
>     container_name: zabbix-web
>     environment:
>       DB_SERVER_HOST: mysql
>       MYSQL_DATABASE: zabbix
>       MYSQL_USER: zabbix
>       MYSQL_PASSWORD: zabbix
>       ZBX_SERVER_HOST: zabbix-server
>       PHP_TZ: Europe/Paris
>     depends_on:
>       - mysql
>       - zabbix-server
>     ports:
>       - "8080:8080"
>     restart: unless-stopped
> 
> volumes:
>   zabbix-mysql:
> EOF
> 
> docker compose down -v 2>/dev/null || true
> docker compose up -d
> 
> ```
> 


---

**Accès Web** :

- WordPress : `http://<IP_SERVEUR>:8080`
- Zabbix : `http://<IP_SERVEUR>:8080`

Identifiants Zabbix par défaut : `Admin / zabbix`

---
