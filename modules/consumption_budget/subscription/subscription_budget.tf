resource "azurerm_consumption_budget_subscription" "this" {
  name            = var.settings.name
  subscription_id = var.subscription_id

  amount     = var.settings.amount
  time_grain = var.settings.time_grain

  time_period {
    start_date = try(var.settings.time_period.start_date, join("", [formatdate("YYYY-MM", timestamp()), "-01T00:00:00Z"]))
    end_date   = try(var.settings.time_period.end_date, null)
  }

  dynamic "notification" {
    for_each = var.settings.notifications

    content {
      operator  = notification.value.operator
      threshold = notification.value.threshold

      contact_emails = try(notification.value.contact_emails, [])
      contact_groups = try(notification.value.contact_groups, try(flatten([
        for key, value in var.monitor_action_groups : value.id
        if contains(notification.value.contact_groups_keys, key)
        ]), [])
      )
      contact_roles = try(notification.value.contact_roles, [])
      enabled       = try(notification.value.enabled, true)
    }
  }

  dynamic "filter" {
    for_each = try(var.settings.filter, null) == null ? [] : [1]

    content {
      dynamic "dimension" {
        for_each = {
          for key, value in try(var.settings.filter.dimensions, {}) : key => value
          if lower(value.name) != "resource_group_key"
        }

        content {
          name     = dimension.value.name
          operator = try(dimension.value.operator, "In")
          values   = dimension.value.values
        }
      }

      dynamic "dimension" {
        for_each = {
          for key, value in try(var.settings.filter.dimensions, {}) : key => value
          if lower(value.name) == "resource_group_key"
        }

        content {
          name     = "ResourceId"
          operator = try(dimension.value.operator, "In")
          values = try(flatten([
            for key, value in var.resource_groups[try(dimension.value.lz_key, var.client_config.landingzone_key)] : value.id
            if contains(dimension.value.values, key)
          ]), [])
        }
      }

      dynamic "tag" {
        for_each = {
          for key, value in try(var.settings.filter.tags, {}) : key => value
        }

        content {
          name     = tag.value.name
          operator = try(tag.value.operator, "In")
          values   = tag.value.values
        }
      }

      dynamic "not" {
        for_each = try(var.settings.filter.not, null) == null ? [] : [1]

        content {
          dynamic "dimension" {
            for_each = {
              for key, value in try(var.settings.filter.not.dimension, {}) : key => value
              if lower(value.name) != "resource_group_key"
            }

            content {
              name     = dimension.value.name
              operator = try(dimension.value.operator, "In")
              values   = dimension.value.values
            }
          }

          dynamic "dimension" {
            for_each = {
              for key, value in try(var.settings.filter.not.dimension, {}) : key => value
              if lower(value.name) == "resource_group_key"
            }

            content {
              name     = "ResourceId"
              operator = try(dimension.value.operator, "In")
              values = try(flatten([
                for key, value in var.resource_groups[try(dimension.value.lz_key, var.client_config.landingzone_key)] : value.id
                if contains(dimension.value.values, key)
              ]), [])
            }
          }

          dynamic "tag" {
            for_each = try(var.settings.filter.not.tag, null) == null ? [] : [1]

            content {
              name     = var.settings.filter.not.tag.name
              operator = try(var.settings.filter.not.tag.operator, "In")
              values   = var.settings.filter.not.tag.values
            }
          }
        }
      }
    }
  }
}