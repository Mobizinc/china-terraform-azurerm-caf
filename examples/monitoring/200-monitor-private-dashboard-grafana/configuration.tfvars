global_settings = {
  regions = {
    region1 = "australiaeast"
  }
  inherit_tags = true
  tags = {
    example = "monitoring/200-monitor-private-dashboard-grafana"
  }
}

resource_groups = {
  grafana_re1 = {
    name   = "grafana-re1"
    region = "region1"
  }
}

monitor_dashboard_grafana = {
  grafana_re1 = {
    name = "grafana-re1-001"

    resource_group = {
      lz_key = "examples"
      key    = "grafana_re1"
    }

    identity = {
      type = "SystemAssigned"
    }

    api_key_enabled                        = true
    auto_generated_domain_name_label_scope = "TenantReuse"
    deterministic_outbound_ip_enabled      = true
    public_network_access_enabled          = false
    grafana_major_version                  = 10
    sku                                    = "Standard"
    zone_redundancy_enabled                = false

    vnet = {
      lz_key = "examples"
      key    = "grafana_re1"
    }

    private_endpoints = {
      dashboard_grafana = {
        name               = "pep-grafana"
        resource_group_key = "grafana_re1"
        lz_key             = "examples"
        vnet_key           = "grafana_re1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "psc-grafana"
          is_manual_connection = false
          subresource_names    = ["grafana"]
        }
        private_dns = {
          lz_key = "examples"
          keys   = ["privatelink.grafana.azure.com"]
        }
      }
    }

    diagnostic_profiles = {
      logs = {
        name             = "dg-operations-logs"
        definition_key   = "dashboard_grafana_logs"
        destination_type = "log_analytics"
        destination_key  = "central_logs_region1"
      }
    }
  }
}
