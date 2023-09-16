resource "azurerm_public_ip" "main" {
  name                = "pip-suse"
  resource_group_name = var.group
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "nic-suse"
  resource_group_name = var.group
  location            = var.location

  ip_configuration {
    name                          = "suse"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  admin_username = "suseadmin"
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-suse"
  resource_group_name   = var.group
  location              = var.location
  size                  = var.size
  admin_username        = local.admin_username
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.main.id]

  custom_data = filebase64("${path.module}/${var.userdata_file}")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = local.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk-suse"
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.vm_version
  }
}

### Adding some permissions avoid this error message when using the CLI:
### az login --identity
### No access was configured for the VM, hence no subscriptions were found. If this is expected, use '--allow-no-subscriptions' to have tenant level access.
# resource "azurerm_role_assignment" "jumpbox_batch" {
#   scope                = var.batch_account_id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_linux_virtual_machine.main.identity[0].principal_id
# }
