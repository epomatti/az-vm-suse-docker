#!/bin/sh

zypper refresh

# Azure CLI
zypper install -y azure-cli
az extension add --name azure-devops -y

# Docker
SUSEConnect -p sle-module-containers/12/x86_64 -r ''
zypper install -y docker
systemctl enable docker.service
systemctl start docker.service

# Prefer docker compose installed as standalone https://docs.docker.com/compose/install/standalone/
# SUSE 12 only supports very old Compose verions in the packages: https://scc.suse.com/packages?name=SUSE%20Linux%20Enterprise%20Server&version=12.5&arch=x86_64&query=docker-compose&module=

dockerComposeVersion=v2.29.7
curl -SL https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
