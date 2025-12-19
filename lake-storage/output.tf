output "storage_account_id" {
  description = "ID Storage account created."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name Storage Account."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Endpoint primary blob."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

# Primary access key for the storage account
output "storage_account_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  description = "Storage account access key"
}

output "storage_account_primary_blob_connection_string" {
  description = "Primary blob connection string of the storage account"
  value       = azurerm_storage_account.this.primary_blob_connection_string
}

