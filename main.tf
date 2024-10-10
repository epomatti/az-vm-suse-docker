terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }
  }
}

locals {
  workload = "suse"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-suse"
  location = var.location
}

module "network" {
  source   = "./modules/network"
  sys      = local.workload
  location = azurerm_resource_group.main.location
  group    = azurerm_resource_group.main.name
}

module "vm_linux" {
  source        = "./modules/suse"
  location      = azurerm_resource_group.main.location
  group         = azurerm_resource_group.main.name
  size          = var.vm_size
  subnet        = module.network.subnet_001_id
  publisher     = var.vm_publisher
  offer         = var.vm_offer
  sku           = var.vm_sku
  vm_version    = var.vm_version
  userdata_file = var.vm_userdata_file
}

module "storage" {
  source              = "./modules/storage"
  workload            = local.workload
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

module "private_endpoints" {
  source              = "./modules/private-endpoints"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_id             = module.network.vnet_id
  subnet_id           = module.network.private_endpoints_subnet_id
  storage_account_id  = module.storage.storage_account_id
}
