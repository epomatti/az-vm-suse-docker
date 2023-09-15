terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-suse"
  location = var.location
}

module "network" {
  source   = "./modules/network"
  sys      = "suse"
  location = azurerm_resource_group.main.location
  group    = azurerm_resource_group.main.name
}

module "vm_linux" {
  source     = "./modules/suse"
  location   = azurerm_resource_group.main.location
  group      = azurerm_resource_group.main.name
  size       = var.vm_size
  subnet     = module.network.subnet_001_id
  publisher  = var.vm_publisher
  offer      = var.vm_offer
  sku        = var.vm_sku
  vm_version = var.vm_version
}
