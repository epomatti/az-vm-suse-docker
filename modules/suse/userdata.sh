#!/bin/sh

sudo zypper refresh
sudo SUSEConnect -p sle-module-containers/12/x86_64 -r ''

# Azure CLI
sudo zypper install -y azure-cli

# Docker
sudo zypper install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

