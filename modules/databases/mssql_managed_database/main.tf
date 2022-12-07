terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.99"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }

}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags         = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))
  arm_filename = "${path.module}/arm_managed_db.json"

  # this is the format required by ARM templates
  parameters_body = {
    serverName = {
      value = var.server_name
    }
    dbName = {
      value = azurecaf_name.manageddb.result
    }
    location = {
      value = var.location
    }
    collation = {
      value = try(var.settings.collation, "SQL_Latin1_General_CP1_CI_AS")
    }
    createMode = {
      value = try(var.settings.createMode, "Default")
    }
    sourceDatabaseId = {
      value = var.sourceDatabaseId
    }
    restorePointInTime = {
      value = try(var.settings.createMode, null) == "PointInTimeRestore" ? var.settings.restorePointInTime : ""
    }
    longTermRetentionBackupResourceId = {
      value = try(var.settings.longTermRetentionBackupResourceId, "")
    }
    retentionDays = {
      value = try(var.settings.retentionDays, 7)
    }
    tags = {
      value = local.tags
    }
  }
}
