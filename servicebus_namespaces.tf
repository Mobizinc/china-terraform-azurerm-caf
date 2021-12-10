module "servicebus_namespaces" {
  depends_on = [module.networking]
  source     = "./modules/servicebus/namespace"
  for_each   = local.servicebus.servicebus_namespaces

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  remote_objects = {
    resource_groups = local.combined_objects_resource_groups
    vnets           = local.combined_objects_networking
  }

}

output "servicebus_namespaces" {
  value = module.servicebus_namespaces
}