module "storage" {
  source = "git::https://github.com/DFE-Digital/terraform-modules.git//aks/storage_account?ref=stable"

  # Required variables - following teacher-success naming conventions
  name                  = "files"
  environment           = var.environment
  azure_resource_prefix = var.azure_resource_prefix
  service_short         = var.service_short
  config_short          = var.config_short

  # Production settings - configurable per environment
  production_replication_type = var.storage_production_replication_type

  # Security settings - secure defaults (hardcoded for security)
  public_network_access_enabled     = true
  infrastructure_encryption_enabled = true
  last_access_time_enabled          = var.storage_last_access_time_enabled

  # Blob management - configurable per environment
  blob_versioning_enabled         = var.storage_blob_versioning_enabled
  blob_delete_retention_days      = var.storage_blob_delete_retention_days
  container_delete_retention_days = var.storage_container_delete_retention_days
  blob_delete_after_days          = 0 # Don't auto-delete files (set to 0)

  # Create container for file uploads
  containers = [
    { name = "uploads" }
  ]

  # Create Microsoft-managed encryption scope
  create_encryption_scope = true
  encryption_scope_name   = "microsoftmanaged"
}
