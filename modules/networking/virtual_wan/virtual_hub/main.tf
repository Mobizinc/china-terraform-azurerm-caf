data "azurerm_subscription" "current" {
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(local.module_tag, var.tags, try(var.virtual_hub_config.tags, null))
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    null = {
      source = "hashicorp/null"
    }
  }

}
