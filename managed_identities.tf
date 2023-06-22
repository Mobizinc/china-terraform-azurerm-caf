
module "managed_identities" {
  source   = "./modules/security/managed_identity"
  for_each = var.managed_identities

  client_config       = local.client_config
  global_settings     = local.global_settings
  name                = each.value.name
  settings            = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
}

#Later can be added the same resources for other type of Federated Identity Credentials, GitHub and other.
resource "azurecaf_name" "fidc" {
  for_each    = local.aks_federated_identity_credentials
  depends_on  = [module.managed_identities]

  name          = each.value.name
  resource_type = "azurerm_user_assigned_identity"
  prefixes      = local.global_settings.prefixes
  random_length = local.global_settings.random_length
  clean_input   = true
  passthrough   = local.global_settings.passthrough
  use_slug      = local.global_settings.use_slug
}

resource "azurerm_federated_identity_credential" "fidc_aks" {
  for_each    = local.aks_federated_identity_credentials
  depends_on  = [module.managed_identities]

  name                = azurecaf_name.fidc[each.key].result
  resource_group_name = local.combined_objects_resource_groups[try(each.value.managed_identity_resource_group_key.lz_key, local.client_config.landingzone_key)][try(each.value.managed_identity_resource_group_key.key, each.value.managed_identity_resource_group_key)].name
  audience            = each.value.audience
  issuer              = each.value.issuer != null ? each.value.issuer : local.combined_objects_aks_clusters[try(each.value.aks_cluster_lz_key, local.client_config.landingzone_key)][each.value.aks_cluster_key].oidc_issuer_url
  parent_id           = module.managed_identities[each.value.managed_identity_key].id
  subject             = each.value.subject != null ? each.value.subject : try("system:serviceaccount:${each.value.kubernetes_namespace}:${each.value.kubernetes_service_account}", null)
}

locals {
  aks_federated_identity_credentials = {
    for mapping in flatten([
      for global_mode, global_values in var.managed_identities : [
        for identity_keys, federated_values in global_values : [
          for object_id_key, object_resources in federated_values : {
            name                                            = object_id_key
            managed_identity_key                            = global_mode
            managed_identity_resource_group_key             = try(global_values.resource_group_key, global_values.resource_group)
            aks_cluster_key                                 = object_resources.aks_cluster_key
            aks_cluster_lz_key                              = object_resources.aks_cluster_lz_key
            issuer                                          = try(object_resources.issuer, null)
            kubernetes_service_account                      = try(object_resources.kubernetes_service_account, null)
            kubernetes_namespace                            = try(object_resources.kubernetes_namespace, null)
            audience                                        = try(object_resources.audience, ["api://AzureADTokenExchange"])
            subject                                         = try(object_resources.subject, null)
          } if can(object_resources.aks_cluster_key) && can(object_resources.aks_cluster_key)
        ] if identity_keys == "federated_credential"
      ]
    ]) : format("%s_%s_%s", mapping.name, mapping.managed_identity_key, mapping.aks_cluster_key) => mapping
  } 
}

output "managed_identities" {
  value = module.managed_identities

}

# "service-one_federated_identity_nonprod-cluster_identity" = {
#   "name"                                = "service-one"
#   "aks_cluster_key"                     = "cluster"
#   "aks_cluster_lz_key"                  = "aks"
#   "issuer"                              = null
#   "kubernetes_service_account"          = "backend"
#   "kubernetes_namespace"                = "api"
#   "audience"                            = "api://AzureADTokenExchange"
#   "subject"                             = null
#   "managed_identity_key"                = "nonprod-cluster"
#   "managed_identity_resource_group_key" = "identity" 
# }
# "database_federated_identity_poc_dev" = {
#   "name"                                = "database"
#   "aks_cluster_key"                     = null
#   "aks_cluster_lz_key"                  = null
#   "issuer"                              = "https://westeurope.oic.dev-cluster.azure.com/652ea6e0-593d-4ec5-1f63-171b4d354180/eeaa8533-ad54-4106-9b8b-c389480b31e7/"
#   "kubernetes_service_account"          = null
#   "kubernetes_namespace"                = null
#   "audience"                            = "api://AzureADTokenExchange"
#   "subject"                             = "system:serviceaccount:kube-public:mssql"
#   "managed_identity_key"                = "poc"
#   "managed_identity_resource_group_key" = {
#     "lz_key"  = "mi"
#     "key"     = "dev" 
#   }
# }
