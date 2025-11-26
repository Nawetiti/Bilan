#!/bin/bash

# Mise à jour de la machine
apt update && apt upgrade -y

# Installation des dépendances
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Ajout du dépôt Docker
curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajout des sources Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour du cache des paquets
apt-get update

# Installation des paquets Docker
apt-get install -y docker-ce docker-ce-cli containerd.io

# Activation et démarrage de Docker
systemctl enable docker
systemctl start docker
systemctl status docker
