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
  }
}

locals {
  target_resource_id = can(var.settings.vmss_key) || can(var.settings.target_resource.vmss_key) ? var.remote_objects.virtual_machine_scale_sets[try(var.settings.target_resource.lz_key, var.client_config.landingzone_key)][try(var.settings.target_resource.vmss_key, var.settings.vmss_key)].id : var.remote_objects.app_service_plans[try(var.settings.target_resource.lz_key, var.client_config.landingzone_key)][var.settings.target_resource.app_service_plan_key].id
}
