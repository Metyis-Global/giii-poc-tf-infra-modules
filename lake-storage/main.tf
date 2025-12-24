# Creates an Azure Storage Account resource
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.replication_type
  account_kind             = var.storage_kind
  tags                     = var.tags
  
  min_tls_version        = var.min_tls_version

  # ADLS Gen2 (hierarchical namespace)
  is_hns_enabled = var.enable_hns
  
  # Use the passed parameter for public network access
  public_network_access_enabled = var.public_network_access_enabled

  shared_access_key_enabled   = var.shared_access_key_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  # Configures network access rules for the storage account
  network_rules {
    bypass              = var.bypass
    default_action      = var.default_action
    virtual_network_subnet_ids = var.allowed_subnet_ids
    ip_rules            = var.allowed_ip_range
  }
      
  blob_properties {
    delete_retention_policy {
      days    = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }
}

# Creates storage containers within the storage account
resource "azurerm_storage_container" "storage_containers" {
  count                 = length(var.storage_containers)
  name                  = var.storage_containers[count.index]
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# Assigns roles to the specified principal for accessing the storage account
resource "azurerm_role_assignment" "role_assignment" {
  count                = length(var.azure_roles)
  scope                = var.role_assignment_scope
  role_definition_name = var.azure_roles[count.index]
  principal_id         = var.principal_id
}

# Sets up diagnostic logging for the storage account, sending logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "default_settings" {
  
  count = length(var.log_analytics_workspace_id) > 0 ? 1 : 0


  name                       = format("default-storage-%s", var.storage_account_name)
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Configures metrics to be collected
  metric {
    category = "Transaction"

    retention_policy {
      enabled = false
    }
  }
}

# Configures diagnostic settings for Blob services within the storage account
resource "azurerm_monitor_diagnostic_setting" "default_settings_blob" {
count = length(var.log_analytics_workspace_id) > 0 ? 1 : 0

  name                       = format("default-blob-%s", var.storage_account_name)
  target_resource_id         = format("%s/blobServices/default", azurerm_storage_account.this.id)
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Enable logs for read, write, and delete operations
  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }
  # Collect metrics related to transactions
  metric {
    category = "Transaction"

    retention_policy {
      enabled = false # No retention policy for metrics
    }
  }
}

# Applies a storage management policy to the storage account
resource "azurerm_storage_management_policy" "this" {
  storage_account_id = azurerm_storage_account.this.id

  rule {
    name    = "retention-policy"
    enabled = true
    # Filters define which blobs the rule applies to block blobs
    filters {
      blob_types = ["blockBlob"]
    }

    # Defines actions for managing blobs (e.g., tiering to cool, archiving, deletion)
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30 # Move to cool storage after 30 days
        tier_to_archive_after_days_since_modification_greater_than = 90 # Move to archive after 90 days
        delete_after_days_since_modification_greater_than          = 2555 # Delete after ~7 years
      }
    }
  }
}

