variable "settings" {
  type = any
}

variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}

variable "cosmosdb_account_name" {}