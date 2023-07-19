
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
