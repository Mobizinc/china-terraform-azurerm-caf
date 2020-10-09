

module virtual_machines {
  source     = "./modules/compute/virtual_machine"
  depends_on = [module.keyvault_access_policies]
  for_each   = local.compute.virtual_machines

  global_settings                  = local.global_settings
  settings                         = each.value
  resource_group_name              = module.resource_groups[each.value.resource_group_key].name
  location                         = lookup(each.value, "region", null) == null ? module.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  vnets                            = local.combined_objects_networking
  managed_identities               = local.combined_objects_managed_identities
  boot_diagnostics_storage_account = try(module.diagnostic_storage_accounts[each.value.boot_diagnostics_storage_account_key].primary_blob_endpoint, {})
  keyvault_id                      = local.combined_objects_keyvaults[each.value.keyvault_key].id
  diagnostics                      = local.diagnostics
  public_ip_addresses              = local.combined_objects_public_ip_addresses
}


output virtual_machines {
  value     = module.virtual_machines
  sensitive = true
}
