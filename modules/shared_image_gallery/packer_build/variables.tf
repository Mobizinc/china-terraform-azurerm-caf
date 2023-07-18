variable "build_resource_group_name" {
  type    = any
  default = {}
}
variable "client_config" {}
variable "global_settings" {}
variable "settings" {}
variable "resource_group" {
  description = "Resource group object"
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = bool
}
variable "gallery_name" {}
variable "image_name" {}
variable "key_vault_id" {}
variable "tenant_id" {}
variable "subscription" {}
variable "managed_identities" {
  type    = any
  default = {}
}
variable "vnet_name" {
  type    = any
  default = {}
}
variable "subnet_name" {
  type    = any
  default = {}
}
