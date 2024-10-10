output "storage_account_id" {
  value = azurerm_storage_account.default.id
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.default.primary_blob_endpoint
}

output "hello_blob_url" {
  value = azurerm_storage_blob.hello.url
}
