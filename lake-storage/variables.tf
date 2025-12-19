variable "storage_account_name" {
  type        = string
  description = "Specifies the name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure Location."
}

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "Defines the Tier to use for this storage account Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium."
}

variable "replication_type" {
  type        = string
  default     = "LRS"
  description = "Replication type (LRS, GRS etc.)."
}

variable "storage_kind" {
  type        = string
  default     = "StorageV2"
  description = "Kind of Storage (StorageV2, BlobStorage, etc.)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags that will be added to resource"
}

variable "enable_hns" {
  type        = bool
  default     = true
  description = "ADLS Gen2 (hierarchical namespace)."
}

variable "bypass" {
  type        = list(string)
  default     = ["AzureServices"]
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
}

variable "default_action" {
  type        = string
  description = "Specifies the default action: Deny or Allow."
}

variable "allowed_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of allowed subnets ids for private endpoints or firewall."
}

variable "allowed_ip_range" {
  type        = list(string)
  default     = []
  description = "List of allowed IP's"
}

variable "storage_containers" {
  type        = list(string)
  default     = []
  description = "Specify the names of containers (ex.: ['raw','curated'])."
}

variable "azure_roles" {
  type        = list(string)
  default     = []
  description = "Specify the roles that we want to add in role assignment."
}

variable "principal_id" {
  type        = string
  default     = null
  description = "The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to"
}

variable "role_assignment_scope" {
  type        = string
  default     = ""
  description = "The scope at which the Role Assignment applies."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = ""
  description = "Log Analytics workspace id to be used with container logs"
}

# variable "allow_blob_public_access" {
#   type    = bool
#   default = false
#   description = "Controls whether public access to blobs is allowed. By default false to comply with security best practices."
# }

variable "min_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "Minimum TLS version to accept for HTTPS connections."
}

variable "public_network_access_enabled" {
  description = "Indicates whether public network access is enabled"
  type        = bool
}

variable "shared_access_key_enabled" {
  description = "If account key access is enabled"
  type        = bool
}

variable "allow_nested_items_to_be_public" {
  type    = bool
}