# naming convention
resource "azurecaf_name" "law" {
  name          = var.log_analytics.name
  resource_type = "azurerm_log_analytics_workspace"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = azurecaf_name.law.result
  location            = lookup(var.settings, "region", null) == null ? local.resource_group.location : var.global_settings.regions[var.settings.region]
  resource_group_name = local.resource_group.name
  sku                 = lookup(var.log_analytics, "sku", "PerGB2018")
  retention_in_days   = lookup(var.log_analytics, "retention_in_days", 30)
  tags                = local.tags
}