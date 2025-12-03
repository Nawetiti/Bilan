# 📋 Scripts Docker Debian 12 - README

Ce dépôt contient trois scripts simples pour installer rapidement un environnement Docker, WordPress, et Zabbix sur une machine Debian 12. Chaque script peut être utilisé indépendamment pour déployer ces services essentiels.

## Sommaire

- [install_docker.sh](#install_dockersh)
- [install_wordpress.sh](#install_wordpresssh)
- [install_zabbix.sh](#install_zabbixsh)

---

## install_docker.sh

Installe Docker CE et Docker Compose sur Debian 12 en quelques secondes.

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

## install_zabbix.sh

Installe Zabbix Server et Web avec une base MySQL en Docker. Interface accessible sur le port 8081.

**Usage** :


```
chmod +x install_zabbix.sh  
./install_zabbix.sh
```


---

**Accès Web** :

- WordPress : `http://<IP_SERVEUR>:8080`
- Zabbix : `http://<IP_SERVEUR>:8081`

Identifiants Zabbix par défaut : `Admin / zabbix`

---
