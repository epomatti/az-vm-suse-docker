output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_001_id" {
  value = azurerm_subnet.main.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoint.id
}
