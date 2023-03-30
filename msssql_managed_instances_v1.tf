output "mssql_managed_instances" {
  value = merge(
    module.mssql_managed_instances,
    module.mssql_managed_instances_v1
  )
}
output "mssql_managed_instances_secondary" {
  value = merge(
    module.mssql_managed_instances_secondary,
    module.mssql_managed_instances_secondary_v1
  )
}
output "mssql_mi_failover_groups" {
  value = merge(
    module.mssql_mi_failover_groups,
    module.mssql_mi_failover_groups_v1
  )
}
module "mssql_managed_instances_v1" {
  source = "./modules/databases/mssql_managed_instance_v1"
  for_each = {
    for key, value in local.database.mssql_managed_instances : key => value
    if try(value.version, "") == "v1"
  }
  depends_on = [module.routes]

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value
  subnet_id       = can(each.value.networking.subnet_id) ? each.value.networking.subnet_id : local.combined_objects_networking[try(each.value.networking.lz_key, local.client_config.landingzone_key)][each.value.networking.vnet_key].subnets[each.value.networking.subnet_key].id

  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  resource_group_id   = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].id
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  keyvault            = can(each.value.administrator_login_password) ? null : local.combined_objects_keyvaults[try(each.value.keyvault.lz_key, local.client_config.landingzone_key)][try(each.value.keyvault.key, each.value.keyvault_key)]
  primary_server_id   = null
}

module "mssql_managed_instances_secondary_v1" {
  source = "./modules/databases/mssql_managed_instance_v1"
  for_each = {
    for key, value in local.database.mssql_managed_instances_secondary : key => value
    if try(value.version, "") == "v1"
  }
  depends_on = [module.routes]

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  resource_group_id   = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].id
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  subnet_id           = can(each.value.networking.subnet_id) ? each.value.networking.subnet_id : local.combined_objects_networking[try(each.value.networking.lz_key, local.client_config.landingzone_key)][each.value.networking.vnet_key].subnets[each.value.networking.subnet_key].id
  primary_server_id   = local.combined_objects_mssql_managed_instances[try(each.value.primary_server.lz_key, local.client_config.landingzone_key)][each.value.primary_server.mi_server_key].id
  keyvault            = can(each.value.administrator_login_password) ? null : local.combined_objects_keyvaults[try(each.value.keyvault.lz_key, local.client_config.landingzone_key)][try(each.value.keyvault.key, each.value.keyvault_key)]
}

module "mssql_mi_failover_groups_v1" {
  source = "./modules/databases/mssql_managed_instance_v1/failover_group"
  for_each = {
    for key, value in local.database.mssql_mi_failover_groups : key => value
    if try(value.version, "") == "v1"
  }
  depends_on = [module.mssql_managed_instances_secondary]
  
  global_settings     = local.global_settings
  settings            = each.value
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

  primaryManagedInstanceId = local.combined_objects_mssql_managed_instances[try(each.value.primary_server.lz_key, local.client_config.landingzone_key)][each.value.primary_server.mi_server_key].id
  partnerManagedInstanceId = module.mssql_managed_instances_secondary[each.value.secondary_server.mi_server_key].id
  partnerRegion            = module.mssql_managed_instances_secondary[each.value.secondary_server.mi_server_key].location
}

# module "mssql_mi_administrators_v1" {
#   source = "./modules/databases/mssql_managed_instance_v1/administrator"
#     for_each = {
#     for key, value in local.database.mssql_mi_administrators : key => value
#     if try(value.version, "") == "v1"
#   }
#   depends_on = [module.azuread_roles_sql_mi, module.azuread_roles_sql_mi_secondary]

#   resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

#   settings            = each.value
#   user_principal_name = try(each.value.user_principal_name, null)
#   group_id            = try(each.value.azuread_group_id, local.combined_objects_azuread_groups[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.azuread_group_key].id, null)
#   group_name          = try(local.combined_objects_azuread_groups[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.azuread_group_key].name, null)
# }

# module "mssql_mi_secondary_tde" {
#   source = "./modules/databases/mssql_managed_instance/tde"

#   //depends_on =
#   for_each = local.database.mssql_mi_secondary_tdes

#   resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

#   mi_name            = module.mssql_managed_instances_secondary[each.value.mi_server_key].name
#   keyvault_key       = try(local.combined_objects_keyvault_keys[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.keyvault_key_key], null)
#   is_secondary_tde   = true
#   secondary_keyvault = try(local.combined_objects_keyvaults[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.secondary_keyvault_key], null)
# }

#Both initial setup and rotation of the TDE protector must be done on the secondary first, and then on primary.
# module "mssql_mi_tde" {
#   source     = "./modules/databases/mssql_managed_instance/tde"
#   depends_on = [module.mssql_mi_secondary_tde]

#   //depends_on =
#   for_each = local.database.mssql_mi_tdes

#   resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

#   mi_name      = module.mssql_managed_instances[each.value.mi_server_key].name
#   keyvault_key = try(local.combined_objects_keyvault_keys[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.keyvault_key_key], null)
# }