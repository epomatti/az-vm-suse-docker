resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.sys}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.group
}

resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.sys}"
  location            = var.location
  resource_group_name = var.group
}

resource "azurerm_network_security_rule" "inbound" {
  name                        = "batch-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "outbound" {
  name                        = "batch-outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-001"
  resource_group_name  = var.group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
