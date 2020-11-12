global_settings = {
  default_region = "region1"
  regions = {
    region1 = "southeastasia"
    region2 = "eastasia"
  }
}

resource_groups = {
  networking_region1 = {
    name   = "mi-networking-rg1"
    region = "region1"
  }
  networking_region2 = {
    name   = "mi-networking-rg2"
    region = "region2"
  }
  sqlmi_region1 = {
    name   = "sqlmi-rg1"
    region = "region1"
  }
  sqlmi_region2 = {
    name   = "sqlmi-rg2"
    region = "region2"
  }
}

vnets = {
  sqlmi_region1 = {
    resource_group_key = "networking_region1"
    vnet = {
      name          = "sqlmi-rg1"
      address_space = ["172.25.88.0/21"]
    }
    subnets = {
      sqlmi1 = {
        name              = "sqlmi1"
        cidr              = ["172.25.88.0/24"]
        nsg_key           = "sqlmi"
        route_table_key   = "sqlmi1"
        delegation = {
          name = "sqlmidelegation"
          service_delegation = "Microsoft.Sql/managedInstances"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action", 
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", 
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
        }
      }
    }
  }
  sqlmi_region2 = {
    resource_group_key = "networking_region2"
    vnet = {
      name          = "sqlmi-rg2"
      address_space = ["172.25.96.0/21"]
    }
    subnets = {
      sqlmi2 = {
        name              = "sqlmi2"
        cidr              = ["172.25.96.0/24"]
        nsg_key           = "sqlmi"
        route_table_key   = "sqlmi2"
        delegation = {
          name = "sqlmidelegation"
          service_delegation = "Microsoft.Sql/managedInstances"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action", 
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", 
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
        }
      }
    }
  }
}

network_security_group_definition = {
  sqlmi = {
    nsg = [
      
    ]
  }
}

route_tables = {
  sqlmi1 = {
    name               = "sqlmi1"
    resource_group_key = "networking_region1"
  }
  sqlmi2 = {
    name               = "sqlmi2"
    resource_group_key = "networking_region2"
  }
}

vnet_peerings = {

  # Establish a peering with the devops vnet
  mi_region1-TO-mi_region2 = {
    name = "mi_region1-TO-mi_region2"
    from = {
      vnet_key = "sqlmi_region1"
    }
    to = {
      vnet_key = "sqlmi_region2"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }

  # Inbound peer with the devops vnet
  mi_region2-TO-mi_region1 = {
    name = "mi_region2-TO-mi_region1-TO-ase_region1"
    from = {
      vnet_key = "sqlmi_region2"
    }
    to = {
      vnet_key = "sqlmi_region1"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}


mssql_managed_instances = {
  sqlmi1 = {
    resource_group_key = "sqlmi_region1"
    name = "lz-sql-mi"
    sku = {
      name = "GP_Gen5"
    }
    administratorLogin = "adminuser"
    administratorLoginPassword = "@dm1nu53r@30102020"

    //networking
    vnet_key  = "sqlmi_region1"
    subnet_key = "sqlmi1"

    storageSizeInGB = 32
    vCores          = 8
  }
  # sqlmi2 = {
  #   resource_group_key = "sqlmi_region2"
  #   name = "lz-sql-mi-rg2"
  #   sku = {
  #     name = "GP_Gen5"
  #   }
  #   administratorLogin = "adminuser"
  #   administratorLoginPassword = "@dm1nu53r@11112020"

  #   //networking
  #   vnet_key  = "sqlmi_region2"
  #   subnet_key = "sqlmi2"

  #   storageSizeInGB = 32
  #   vCores          = 8
  # }
}

mssql_managed_databases = {
  managed_db1 = {
    resource_group_key = "sqlmi_region1"
    name               = "lz-sql-managed-db1"
    mi_server_key      = "sqlmi1"
  }
  managed_db2 = {
    resource_group_key = "sqlmi_region1"
    name               = "lz-sql-managed-db2"
    mi_server_key      = "sqlmi1"
  }
}

mssql_managed_databases_restore = {
  managed_db_restore = {
    resource_group_key  = "sqlmi_region1"
    name                = "lz-sql-managed-db-restore"
    mi_server_key       = "sqlmi1"
    createMode          = "PointInTimeRestore"
    source_database_key = "managed_db1"
    restorePointInTime  = "2020-11-11T10:00:00Z"
  }
}

# mssql_mi_failover_groups = {
#   failover-mi = {
#     resource_group_key = "sqlmi_region1"
#     name               = "failover-test"
#     primary_server = {
#       mi_server_key = "sqlmi1"
#     }
#     secondary_server = {
#       mi_server_key = "sqlmi2"
#     }
#     readWriteEndpoint = {
#       failoverPolicy                         = "Automatic"
#       failoverWithDataLossGracePeriodMinutes = "60"
#     }
#   }
# }