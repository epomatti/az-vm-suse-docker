#!/bin/sh

sudo zypper refresh

# Azure CLI
sudo zypper install -y azure-cli
sudo az extension add --name azure-devops -y

# Docker
sudo SUSEConnect -p sle-module-containers/15/x86_64 -r ''
sudo zypper install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Docker Compose
sudo SUSEConnect -p PackageHub/15.5/x86_64
sudo zypper install -y docker-compose
