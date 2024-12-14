#!/bin/sh

zypper refresh


### Install Azure CLI ###
# Azure CLI
zypper install -y azure-cli
az extension add --name azure-devops -y


### Install Docker ###
# Variables
suse_major=15
suse_minor=6
suse_release=$suse_major.$suse_minor
suse_architecture=x86_64

# Docker
SUSEConnect -p sle-module-containers/$suse_major/$suse_architecture -r ''
zypper install -y docker
systemctl enable docker.service
systemctl start docker.service

# Docker Compose
SUSEConnect -p PackageHub/$suse_release/$suse_architecture
zypper install -y docker-compose

### Maven ###
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
sdk install maven
