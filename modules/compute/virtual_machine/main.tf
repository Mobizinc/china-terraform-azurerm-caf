terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.99"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.2.3"
    }
    random = {
      version = "~> 3.3.1"
      source  = "hashicorp/random"
    }
  }

}


locals {
  os_type = lower(var.settings.os_type)
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))
}
