output app_services {
  value     = module.caf.app_services
  sensitive = false
}

output mssql_servers {
  value     = module.caf.mssql_servers
  sensitive = false
}

output redis_caches {
  value     = module.caf.redis_caches
  sensitive = false
}

output private_dns {
  value     = module.caf.private_dns
  sensitive = false
}
