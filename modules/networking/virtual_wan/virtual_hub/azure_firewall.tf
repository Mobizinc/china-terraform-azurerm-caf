# naming convention
resource "azurecaf_name" "virtualhub_fw" {
  count = try(var.virtual_hub_config.deploy_firewall, false) ? 1 : 0

  name          = try(var.virtual_hub_config.firewall_name, null)
  resource_type = "azurerm_firewall"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


# Part of migration from 2.99.0 to 3.7.0
moved {
  from = azurerm_template_deployment.arm_template_vhub_firewall
  to   = azurerm_resource_group_template_deployment.arm_template_vhub_firewall
}

# As per https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-09-01/azurefirewalls
resource "azurerm_resource_group_template_deployment" "arm_template_vhub_firewall" {
  count               = try(var.virtual_hub_config.deploy_firewall, false) ? 1 : 0
  name                = azurecaf_name.virtualhub_fw.0.result
  resource_group_name = var.resource_group_name

  template_content = file("${path.module}/arm_template_vhub_firewall.json")

  parameters_content = jsonencode({
    "vwan_id"  = azurerm_virtual_hub.vwan_hub.id,
    "name"     = var.virtual_hub_config.firewall_name,
    "location" = var.location,
    "Tier"     = "Standard",
  })
  deployment_mode = "Incremental"
}


resource "null_resource" "arm_template_vhub_firewall" {
  count = try(var.virtual_hub_config.deploy_firewall, false) ? 1 : 0

  triggers = {
    resource_id = jsondecode(azurerm_resource_group_template_deployment.arm_template_vhub_firewall[0].output_content).resourceID.value
  }

  provisioner "local-exec" {
    command     = format("%s/scripts/destroy_resource.sh", path.module)
    when        = destroy
    interpreter = ["/bin/bash"]
    on_failure  = continue

    environment = {
      RESOURCE_IDS = self.triggers.resource_id
    }
  }

}