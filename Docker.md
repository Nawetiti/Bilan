**Installation des dépendances**



installer les paquets suivant :

```
apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
```



**Ajout du dépôt officiel Docker** 

Récupération de la clé GPG :
```
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Liste des sources sur notre machine :

```
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
```

Mise à jour du cache des paquets 

```
sudo apt-get update
```



**Installation des paquets Docker**


```
apt-get install docker-ce docker-ce-cli containerd.io
```



**Vérification de l'installation** 


```
systemctl enable docker
```

```
systemctl status docker
```

```
docker run hello-world
```

Liste de commande :

| Commande           | Fonction                                                               |
| ------------------ | ---------------------------------------------------------------------- |
| `docker ps`        | Affiche la liste des conteneurs en cours d’exécution sur le système​.  |
| `docker ps -a`     | Affiche tous les conteneurs, en cours ou arrêtés (option `-a` = all)​. |
| `docker images`    | Commande d'action sur les images                                       |
| `docker images ls` | Liste toutes les images Docker présentes localement sur la machine     |
| `docker run`       | Ceci envoie l’ordre de démarrage au container spécifié                 |
| `docker stop`      | Ceci envoie l’ordre d’arrêt au container spécifié                      |
| `docker rm`        | Supprimer un container (-f pour forcer la suppression)                 |
| `docker rmi`       | supprimer une image Docker                                             |

> [!Info]
> Pour trouver des images :
> 
> https://hub.docker.com

Ajouter image (par exemple ubuntu/apache2) :

```
Docker pull "nom de l'image"
```


Démarrage d'un container apache 2 en mappant le port 8081 sur le port 80 du container 

```
Docker run -p 8081:80 -d ubuntu/apache2
```


> [!Définition]
>-p 8081:80 : mappe le port 8081 de la machine host vers le port 80 du container 
>
>-d : mode détaché (permet de lancer un conteneur en arrière-plan et de libérer immédiatement le terminal)
>
>ubuntu/apache2 : image


**Création de notre image** 


Dans un répertoire lab0 on crée le fichier dockerfile : 

> [!Code]
> 
> ```
> # --------------- DÉBUT COUCHE OS ------------------- 
> FROM debian:stable-slim 
> # --------------- FIN COUCHE OS --------------------- 
> 
> # MÉTADONNÉES DE L'IMAGE 
> MAINTAINER BTS SIO2 SISR 
> # --------------- DÉBUT COUCHE Installation --------------- 
> RUN apt-get update \ 
> && apt-get install -y vim git htop mc \ 
> && apt-get clean \ 
> && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
> # --------------- FIN COUCHE Installation -----------------
> ```
> 
> Rq:La dernière ligne permet d’effectuer un nettoyage afin d’alléger l’image.
> 
> L'instruction MAINTAINER est considérée comme Obsolète par Docker, il est conseillé d'utiliser LABEL 


| Commande | Fonction                                                                                  |
| -------- | ----------------------------------------------------------------------------------------- |
| FROM     | qui vous permet de définir l'image source                                                 |
| RUN      | qui vous permet d’exécuter des commandes dans votre conteneur                             |
| ADD      | qui vous permet d'ajouter des fichiers dans votre conteneur                               |
| WORKDIR  | qui vous permet de définir votre répertoire de travail                                    |
| EXPOSE   | qui permet de définir les ports d'écoute par défaut                                       |
| VOLUME   | qui permet de définir les volumes utilisables                                             |
| CMD      | qui permet de définir la commande par défaut lors de l’exécution de vos conteneurs Docker |

Création de notre image : 

```
docker build -t btssio:v1.0 .
```

> [!Info]
> 
> docker build [OPTIONS] PATH | URL | -
> 
> 
> 
> `-t` (Tag)
>
> il permet de **nommer** et d'**étiqueter** l'image
> 
> La structure du _tag_ est généralement : `<nom_utilisateur>/<nom_image>:<version>`.
> 
> 
> Ici, le point (`.`) signifie : "Utilise le **répertoire courant** comme contexte de construction." 


A l'aide de 

```
docker image ls 
```

Pour lancer notre conteneur à partir de notre image 

```
docker run -tid --name sisr btssio:v1.0
```

> [!Info]
> 
> | **Option** | **Nom complet** | **Explication**                                                                                                                                                                                                                                       |
| ---------- | --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`-t`**   | `--tty`         | Alloue un **pseudo-TTY** (terminal). C'est essentiel pour interagir avec le conteneur, notamment si vous prévoyez d'y attacher un shell (`bash`). Sans cela, l'entrée/sortie du conteneur peut être étrange ou le shell peut s'arrêter immédiatement. |
| **`-i`**   | `--interactive` | Maintient le flux d'entrée (`STDIN`) **ouvert**, même si le conteneur n'est pas "attaché". C'est crucial quand on utilise `-t`, car cela permet de **taper des commandes** dans le conteneur une fois que vous y êtes connecté.                       |
| **`-d`**   | `--detach`      | Exécute le conteneur en **mode détaché** (en arrière-plan). Après le lancement, Docker retourne immédiatement le prompt de votre terminal, et le conteneur continue de s'exécuter silencieusement
>
>| **Option**         | **Explication**                                                                                                                                           |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`--name <NOM>`** | Permet d'attribuer un **nom lisible et facile à retenir** à votre conteneur. Sans cette option, Docker génère un nom aléatoire (ex: `boring_archimedes`). |
>


Pour accéder à notre container :

```
docker exec -ti sisr bash
```
