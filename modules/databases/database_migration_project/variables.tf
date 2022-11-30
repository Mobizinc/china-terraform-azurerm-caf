variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "settings" {}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "remote_objects" {
  description = "Combined objects for virtual networks used in the module."
  type        = map(any)
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}

variable "database_migration_services" {
  description = "Combined object with the database migration services."
}