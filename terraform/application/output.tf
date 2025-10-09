output "url" {
  value = module.web_application.url
}

output "external_urls" {
  value = [
    module.web_application.url
  ]
}

output "storage_account_name" {
  value       = module.storage.name
  description = "Name of the storage account for file uploads"
}

output "storage_account_connection_string" {
  value       = module.storage.primary_connection_string
  sensitive   = true
  description = "Connection string for storage account"
}

output "storage_account_blob_endpoint" {
  value       = module.storage.primary_blob_endpoint
  description = "Primary blob endpoint for storage account"
}
