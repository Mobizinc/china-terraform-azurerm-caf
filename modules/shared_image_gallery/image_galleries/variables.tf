
variable "resource_group_name" {}
variable "location" {}
variable "diagnostics" {}
variable "client_config" {}
variable "global_settings" {
  type = any

}
variable "settings" {}
variable "base_tags" {}