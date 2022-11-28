terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.99"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }

}

locals {
  databases = [
    for key, value in var.settings.databases : var.databases[try(value.lz_key, var.client_config.landingzone_key)][value.database_key].id
  ]
}