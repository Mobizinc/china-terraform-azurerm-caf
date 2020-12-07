module "storage_account" {
  source   = "../../private_endpoint"
  for_each = try(var.private_endpoints.storage_accounts, {})

  global_settings     = var.global_settings
  settings            = each.value
  resource_id         = try(var.remote_objects.storage_accounts[each.value.lz_key][each.key].id, var.remote_objects.storage_accounts[var.client_config.landingzone_key][each.key].id)
  subnet_id           = var.subnet_id
  name                = try(each.value.name, each.key)
  resource_group_name = try(var.resource_groups[each.value.resource_group_key].name, var.vnet_resource_group_name)
  location            = var.vnet_location         # The private endpoint must be deployed in the same region as the virtual network.
  base_tags           = var.base_tags
}