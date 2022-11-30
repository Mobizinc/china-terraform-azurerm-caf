variable "custom_role" {}
variable "subscription_primary" {}
variable "assignable_scopes" {
  default = []
}
variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
