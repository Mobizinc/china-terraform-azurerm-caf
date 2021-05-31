resource "azurecaf_name" "acr" {
  name          = var.name
  resource_type = "azurerm_container_registry"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_container_registry" "acr" {
  name                     = azurecaf_name.acr.result
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
  admin_enabled            = var.admin_enabled
  tags                     = local.tags

  dynamic "network_rule_set" {
    for_each = var.network_rule_set

    content {
      default_action = try(var.network_rule_set.default_action, "Allow")
  
      dynamic "ip_rule" {
        for_each = try(network_rule_set.value.ip_rules, {})

        content {
          action   = "Allow"
          ip_range = ip_rule.value.ip_range
        }
      }
      dynamic "virtual_network" {
        for_each = try(network_rule_set.value.virtual_networks, {})

        content {
          action    = "Allow"
          subnet_id = try(var.vnets[try(virtual_network.value.lz_key, var.client_config.landingzone_key)][virtual_network.value.vnet_key].subnets[virtual_network.value.subnet_key].id, {})
        }
      }
    }
  }

  dynamic "georeplications" {
    for_each = var.georeplications

    content {
      location = var.global_settings.regions[georeplications.key]
      tags     = try(georeplications.value.tags)
    }
  }
}

