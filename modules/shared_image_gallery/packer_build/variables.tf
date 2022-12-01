variable "resource_group_name" {
  type = string
}
variable "build_resource_group_name" {
  default = {}
}
variable "location" {
  type = string
}
variable "client_config" {
  type = map(any)
}
variable "global_settings" {
  type = any

}
variable "settings" {
  type = any
}
variable "base_tags" {}
variable "gallery_name" {}
variable "image_name" {}
variable "key_vault_id" {}
variable "tenant_id" {
  type = string
}
variable "subscription" {}
variable "managed_identities" {
  type    = map(any)
  default = {}
}
variable "vnet_name" {
  default = {}
}
variable "subnet_name" {
  default = {}
}


