output id {
  value     = azurerm_role_definition.custom_role.id
  sensitive = true
}

output role_definition_resource_id {
  value     = azurerm_role_definition.custom_role.role_definition_resource_id
  sensitive = true
}