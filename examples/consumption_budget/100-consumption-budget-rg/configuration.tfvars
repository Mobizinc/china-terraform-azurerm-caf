global_settings = {
  default_region = "region1"
  regions = {
    region1 = "southeastasia"
  }
  random_length = 5
}

resource_groups = {
  test = {
    name = "test"
  }
}

consumption_budgets = {
  test_budget = {
    resource_group = {
      # accepts either id or key to get resource group id
      # id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroup1"
      key = "test"
    }
    name       = "example"
    amount     = 1000
    time_grain = "Monthly"
    time_period = {
      # uncomment to customize start_date
      # start_date = "2022-06-01T00:00:00Z"
    }
    notifications = {
      default = {
        enabled   = true
        threshold = 90.0
        operator  = "EqualTo"
      }
      contact_email = {
        enabled   = true
        threshold = 90.0
        operator  = "EqualTo"
        contact_emails = [
          "foo@example.com",
          "bar@example.com",
        ]
      }
      contact_role = {
        enabled   = true
        threshold = 90.0
        operator  = "EqualTo"
        contact_roles = [
          "Owner",
        ]
      }
    }
    filter = {
      dimensions = {
        explicit_name = {
          name = "ResourceGroupName"
          values = [
            "example",
          ]
        }
      }
    }
  }
}