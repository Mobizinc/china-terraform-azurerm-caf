module "vmware_private_clouds" {
  source   = "./modules/compute/vmware_private_clouds"
  for_each = local.compute.vmware_private_clouds

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_group_name = local.resource_groups[each.value.resource_group_key].name
  location            = lookup(each.value, "region", null) == null ? local.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  base_tags           = try(local.global_settings.inherit_tags, false) ? local.resource_groups[each.value.resource_group_key].tags : {}
  keyvaults          = local.combined_objects_keyvaults
}


output "vmware_private_clouds" {
  value = module.vmware_private_clouds
}


module "vmware_clusters" {
  source   = "./modules/compute/vmware_clusters"
  for_each = local.compute.vmware_clusters
  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value
  vmware_cloud_id = local.combined_objects_vmware_private_clouds[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.vmware_private_cloud_key].id
}



output "vmware_clusters" {
  value = module.vmware_clusters

}

