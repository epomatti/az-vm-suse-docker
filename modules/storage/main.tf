data "azuread_client_config" "current" {}

locals {
  current_client_object_id = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_account" "default" {
  name                       = "st${var.workload}82913"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  # If true, will be further controlled by network_rules below
  public_network_access_enabled = false

  network_rules {
    default_action = "Deny"
    # ip_rules                   = var.allowed_public_ips
    ip_rules                   = []
    virtual_network_subnet_ids = []
    bypass                     = ["AzureServices"]
  }

  lifecycle {
    ignore_changes = [
      network_rules[0].private_link_access
    ]
  }
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.current_client_object_id
}

resource "azurerm_role_assignment" "storage_blob_data_owner" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = local.current_client_object_id
}
