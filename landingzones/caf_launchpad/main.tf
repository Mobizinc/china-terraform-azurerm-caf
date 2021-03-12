terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.50"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.2.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
  }
  required_version = ">= 0.13"
}


provider "azurerm" {
  features {}
}

resource "random_string" "prefix" {
  count   = var.prefix == null ? 1 : 0
  length  = 4
  special = false
  upper   = false
  number  = false
}

resource "random_string" "alpha1" {
  count   = var.prefix == null ? 1 : 0
  length  = 1
  special = false
  upper   = false
  number  = false
}

locals {

  global_settings = {
    default_region     = var.default_region
    environment        = var.environment
    inherit_tags       = var.inherit_tags
    passthrough        = var.passthrough
    prefix             = var.prefix
    prefixes           = var.prefix == "" ? null : [try(var.prefix, random_string.prefix.0.result)]
    prefix_with_hyphen = var.prefix == "" ? null : format("%s-", try(var.prefix, random_string.prefix.0.result))
    random_length      = var.random_length
    regions            = var.regions
    tags               = var.tags
    use_slug           = var.use_slug
  }

  tfstates = map(
    var.landingzone.key,
    local.backend[var.landingzone.backend_type]
  )

  backend = {
    azurerm = {
      storage_account_name = module.launchpad.storage_accounts[var.launchpad_key_names.tfstates[0]].name
      container_name       = module.launchpad.storage_accounts[var.launchpad_key_names.tfstates[0]].containers["tfstate"].name
      resource_group_name  = module.launchpad.storage_accounts[var.launchpad_key_names.tfstates[0]].resource_group_name
      key                  = var.tf_name
      level                = var.landingzone.level
      tenant_id            = data.azurerm_client_config.current.tenant_id
      subscription_id      = data.azurerm_client_config.current.subscription_id
    }
  }

}

data "azurerm_client_config" "current" {}