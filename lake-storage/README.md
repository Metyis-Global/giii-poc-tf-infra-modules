# Azure Storage Account Module

This module provisions an **Azure Storage Account**, including **storage containers**, **role assignments**, **diagnostic settings**, and **management policies**.

## Resources

- **azurerm_storage_account** - Creates an Azure Storage Account.
- **azurerm_storage_container** - Creates storage containers within the storage account.
- **azurerm_role_assignment** - Assigns roles to users or applications for accessing the storage account.
- **azurerm_monitor_diagnostic_setting** - Configures diagnostic settings for logs and metrics.
- **azurerm_storage_management_policy** - Applies lifecycle management policies to storage blobs.

## Module Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `storage_account_name` | The name of the Storage Account. | `string` | n/a | yes |
| `resource_group_name` | The name of the resource group in which to create the Storage Account. | `string` | n/a | yes |
| `location` | The Azure region where the Storage Account will be created. | `string` | n/a | yes |
| `storage_account_tier` | The performance tier (e.g., `Standard` or `Premium`). | `string` | n/a | yes |
| `replication_type` | The replication strategy (e.g., `LRS`, `GRS`, `ZRS`). | `string` | n/a | yes |
| `storage_kind` | The kind of storage account (e.g., `StorageV2`, `BlobStorage`). | `string` | `StorageV2` | no |
| `enable_hns` | Whether to enable **Azure Data Lake Storage Gen2** (Hierarchical Namespace). | `bool` | `false` | no |
| `bypass` | List of services that bypass network rules (e.g., `["AzureServices"]`). | `list(string)` | `[]` | no |
| `default_action` | The default action for network rules (`Allow` or `Deny`). | `string` | `Deny` | no |
| `storage_containers` | List of containers to be created inside the Storage Account. | `list(string)` | `[]` | no |
| `azure_roles` | List of Azure RBAC roles to assign to the storage account. | `list(string)` | `[]` | no |
| `role_assignment_scope` | The scope for role assignments (e.g., the Storage Account ID). | `string` | n/a | yes |
| `principal_id` | The ID of the principal (user, service principal, or managed identity) receiving role assignments. | `string` | n/a | yes |
| `log_analytics_workspace_id` | The Log Analytics Workspace ID for diagnostic settings. | `string` | n/a | yes |
| `tags` | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Module Outputs

| Name | Description |
|------|-------------|
| `storage_account_id` | The resource ID of the Storage Account. |
| `primary_blob_endpoint` | The primary endpoint for blob storage. |
| `primary_queue_endpoint` | The primary endpoint for queue storage. |

## Example Usage

```hcl
module "storage_account" {
  source                 = "./modules/storage_account"
  storage_account_name   = "mystorage"
  resource_group_name    = "rg-storage"
  location              = "East US"
  storage_account_tier   = "Standard"
  replication_type       = "LRS"
  storage_kind          = "StorageV2"
  enable_hns            = true

  storage_containers = ["logs", "backup"]
  azure_roles        = ["Storage Blob Data Reader", "Storage Blob Data Contributor"]
  role_assignment_scope = "/subscriptions/xxxx/resourceGroups/rg-storage/providers/Microsoft.Storage/storageAccounts/mystorage"
  principal_id      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  log_analytics_workspace_id = "/subscriptions/xxxx/resourceGroups/rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/loganalytics"

  tags = {
    Environment = "Production"
  }
}
