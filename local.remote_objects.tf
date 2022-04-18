locals {
  remote_objects = {
    aks_clusters                                   = try(local.combined_objects_aks_clusters, null)
    api_management                                 = try(local.combined_objects_api_management, null)
    api_management_api                             = try(local.combined_objects_api_management_api, null)
    management_api_operation                       = try(local.combined_objects_api_management_api_operation, null)
    management_logger                              = try(local.combined_objects_api_management_logger, null)
    app_config                                     = try(local.combined_objects_app_config, null)
    app_service_environments                       = try(local.combined_objects_app_service_environments, null)
    app_service_plans                              = try(local.combined_objects_app_service_plans, null)
    app_services                                   = try(local.combined_objects_app_services, null)
    application_gateway_platforms                  = try(local.combined_objects_application_gateway_platforms, null)
    application_gateway_waf_policies               = try(local.combined_objects_application_gateway_waf_policies, null)
    application_gateways                           = try(local.combined_objects_application_gateways, null)
    application_insights                           = try(local.combined_objects_application_insights, null)
    application_security_groups                    = try(local.combined_objects_application_security_groups, null)
    availability_sets                              = try(local.combined_objects_availability_sets, null)
    azure_container_registries                     = try(local.combined_objects_azure_container_registries, null)
    azuread_applications                           = try(local.combined_objects_azuread_applications, null)
    azuread_apps                                   = try(local.combined_objects_azuread_apps, null)
    azuread_groups                                 = try(local.combined_objects_azuread_groups, null)
    azuread_service_principals                     = try(local.combined_objects_azuread_service_principals, null)
    azuread_users                                  = try(local.combined_objects_azuread_users, null)
    firewall_policies                              = try(local.combined_objects_azurerm_firewall_policies, null)
    firewalls                                      = try(local.combined_objects_azurerm_firewalls, null)
    batch_accounts                                 = try(local.combined_objects_batch_accounts, null)
    batch_applications                             = try(local.combined_objects_batch_applications, null)
    batch_certificates                             = try(local.combined_objects_batch_certificates, null)
    batch_jobs                                     = try(local.combined_objects_batch_jobs, null)
    batch_pools                                    = try(local.combined_objects_batch_pools, null)
    cdn_profile                                    = try(local.combined_objects_cdn_profile, null)
    cognitive_services_accounts                    = try(local.combined_objects_cognitive_services_accounts, null)
    consumption_budgets_resource_groups            = try(local.combined_objects_consumption_budgets_resource_groups, null)
    consumption_budgets_subscriptions              = try(local.combined_objects_consumption_budgets_subscriptions, null)
    container_registry                             = try(local.combined_objects_container_registry, null)
    cosmos_dbs                                     = try(local.combined_objects_cosmos_dbs, null)
    databricks_workspaces                          = try(local.combined_objects_databricks_workspaces, null)
    data_factory                                   = try(local.combined_objects_data_factory, null)
    data_factory_integration_runtime_azure_ssis    = try(local.combined_objects_data_factory_integration_runtime_azure_ssis, null)
    data_factory_linked_service_azure_blob_storage = try(local.combined_objects_data_factory_linked_service_azure_blob_storage, null)
    data_factory_linked_service_cosmosdb           = try(local.combined_objects_data_factory_linked_service_cosmosdb, null)
    data_factory_linked_service_mysql              = try(local.combined_objects_data_factory_linked_service_mysql, null)
    data_factory_linked_service_postgresql         = try(local.combined_objects_data_factory_linked_service_postgresql, null)
    data_factory_linked_service_sql_server         = try(local.combined_objects_data_factory_linked_service_sql_server, null)
    data_factory_linked_service_web                = try(local.combined_objects_data_factory_linked_service_web, null)
    data_factory_pipeline                          = try(local.combined_objects_data_factory_pipeline, null)
    data_factory_integration_runtime_self_hosted   = try(local.combined_objects_data_factory_integration_runtime_self_hosted, null)
    database_migration_services                    = try(local.combined_objects_database_migration_services, null)
    dedicated_host_groups                          = try(local.combined_objects_dedicated_host_groups, null)
    dedicated_hosts                                = try(local.combined_objects_dedicated_hosts, null)
    diagnostic_storage_accounts                    = try(local.combined_objects_diagnostic_storage_accounts, null)
    disk_encryption_sets                           = try(local.combined_objects_disk_encryption_sets, null)
    dns_zones                                      = try(local.combined_objects_dns_zones, null)
    ddos_services                                  = try(local.combined_objects_ddos_services, null)
    event_hub_namespaces                           = try(local.combined_objects_event_hub_namespaces, null)
    express_route_circuit_authorizations           = try(local.combined_objects_express_route_circuit_authorizations, null)
    express_route_circuit_peerings                 = try(local.combined_objects_express_route_circuit_peerings, null)
    express_route_circuits                         = try(local.combined_objects_express_route_circuits, null)
    front_door                                     = try(local.combined_objects_front_door, null)
    front_door_waf_policies                        = try(local.combined_objects_front_door_waf_policies, null)
    integration_service_environment                = try(local.combined_objects_integration_service_environment, null)
    keyvault_certificates                          = try(local.combined_objects_keyvault_certificates, null)
    keyvault_certificate_requests                  = try(local.combined_objects_keyvault_certificate_requests, null)
    keyvault_keys                                  = try(local.combined_objects_keyvault_keys, null)
    keyvaults                                      = try(local.combined_objects_keyvaults, null)
    lb                                             = try(local.combined_objects_lb, null)
    lb_backend_address_pool                        = try(local.combined_objects_lb_backend_address_pool, null)
    load_balancers                                 = try(local.combined_objects_load_balancers, null)
    log_analytics                                  = try(local.combined_objects_log_analytics, null)
    logic_app_integration_account                  = try(local.combined_objects_logic_app_integration_account, null)
    logic_app_workflow                             = try(local.combined_objects_logic_app_workflow, null)
    machine_learning                               = try(local.combined_objects_machine_learning, null)
    managed_identities                             = try(local.combined_objects_managed_identities, null)
    monitor_action_groups                          = try(local.combined_objects_monitor_action_groups, null)
    mssql_databases                                = try(local.combined_objects_mssql_databases, null)
    mssql_elastic_pools                            = try(local.combined_objects_mssql_elastic_pools, null)
    mssql_managed_databases                        = try(local.combined_objects_mssql_managed_databases, null)
    mssql_managed_instances                        = try(local.combined_objects_mssql_managed_instances, null)
    mssql_managed_instances_secondary              = try(local.combined_objects_mssql_managed_instances_secondary, null)
    mssql_servers                                  = try(local.combined_objects_mssql_servers, null)
    mysql_servers                                  = try(local.combined_objects_mysql_servers, null)
    nat_gateways                                   = try(local.combined_objects_nat_gateways, null)
    network_security_groups                        = try(local.combined_objects_network_security_groups, null)
    network_watchers                               = try(local.combined_objects_network_watchers, null)
    networking                                     = try(local.combined_objects_networking, null)
    postgresql_servers                             = try(local.combined_objects_postgresql_servers, null)
    private_dns                                    = try(local.combined_objects_private_dns, null)
    private_endpoints                              = try(local.combined_objects_private_endpoints, null)
    proximity_placement_groups                     = try(local.combined_objects_proximity_placement_groups, null)
    public_ip_addresses                            = try(local.combined_objects_public_ip_addresses, null)
    public_ip_prefixes                             = try(local.combined_objects_public_ip_prefixes, null)
    recovery_vaults                                = try(local.combined_objects_recovery_vaults, null)
    redis_caches                                   = try(local.combined_objects_redis_caches, null)
    resource_groups                                = try(local.combined_objects_resource_groups, null)
    servicebus_namespaces                          = try(local.combined_objects_servicebus_namespaces, null)
    servicebus_topics                              = try(local.combined_objects_servicebus_topics, null)
    servicebus_queues                              = try(local.combined_objects_servicebus_queues, null)
    signalr_services                               = try(local.combined_objects_signalr_services, null)
    storage_accounts                               = try(local.combined_objects_storage_accounts, null)
    storage_containers                             = try(local.combined_objects_storage_containers, null)
    synapse_workspaces                             = try(local.combined_objects_synapse_workspaces, null)
    virtual_hub_connections                        = try(local.combined_objects_virtual_hub_connections, null)
    virtual_hub_route_tables                       = try(local.combined_objects_virtual_hub_route_tables, null)
    virtual_hubs                                   = try(local.combined_objects_virtual_hubs, null)
    virtual_machine_scale_sets                     = try(local.combined_objects_virtual_machine_scale_sets, null)
    virtual_machines                               = try(local.combined_objects_virtual_machines, null)
    virtual_subnets                                = try(local.combined_objects_virtual_subnets, null)
    virtual_wans                                   = try(local.combined_objects_virtual_wans, null)
    vmware_clusters                                = try(local.combined_objects_vmware_clusters, null)
    vmware_express_route_authorizations            = try(local.combined_objects_vmware_express_route_authorizations, null)
    vmware_private_clouds                          = try(local.combined_objects_vmware_private_clouds, null)
    vpn_gateway_connections                        = try(local.combined_objects_vpn_gateway_connections, null)
    vpn_sites                                      = try(local.combined_objects_vpn_sites, null)
    wvd_application_groups                         = try(local.combined_objects_wvd_application_groups, null)
    wvd_applications                               = try(local.combined_objects_wvd_applications, null)
    wvd_host_pools                                 = try(local.combined_objects_wvd_host_pools, null)
    wvd_workspaces                                 = try(local.combined_objects_wvd_workspaces, null)
    subscriptions                                  = try(local.combined_objects_subscriptions, null)
  }
}
