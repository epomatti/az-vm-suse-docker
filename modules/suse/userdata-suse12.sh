#!/bin/sh

sudo zypper refresh

# Azure CLI
sudo zypper install -y azure-cli

# Docker
sudo SUSEConnect -p sle-module-containers/12/x86_64 -r ''
sudo zypper install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Docker Compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
