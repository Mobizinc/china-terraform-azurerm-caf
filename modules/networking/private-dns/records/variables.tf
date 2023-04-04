variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  type        = any
  description = "Client configuration object (see module README.md)."
}
variable "resource_group_name" {
  type        = string
  description = "Name of resource groups hosting private DNS zone"
}
variable "zone_name" {
  type        = string
  description = "Name of private DNS zone to associate records with"
}
variable "records" {
  type        = any
  description = "Various DNS records"
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}
variable "tags" {
  type    = any
  default = {}
}