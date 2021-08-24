#
# key is used when
#
# Keys generated when using the password policy
#  Key0 password_policy.rotation.days is an odd number
#  Key1 password_policy.rotation.days is an even number
#

locals {
  password_type   = try(var.settings.type, "password")
  password_policy = try(var.settings.azuread_credential_policy_key, null) == null ? var.policy : var.credential_policy

  start_date = timestamp()

  expiration_date = {
    key  = try(var.settings.azuread_credential_policy_key, null) == null ? timeadd(local.start_date, format("%sh", local.key.days * 24)) : null
    key0 = try(var.settings.azuread_credential_policy_key, null) != null ? timeadd(local.start_date, format("%sh", local.key0.days * 24)) : null
    key1 = try(var.settings.azuread_credential_policy_key, null) != null ? timeadd(local.start_date, format("%sh", local.key1.days * 24)) : null
  }

  description = {
    key = try(format(
      "key-%s-%s",
      formatdate("YYMMDDhhmmss", local.start_date),
      formatdate("YYMMDDhhmmss", local.expiration_date.key)
    ), null)
    key0 = try(format(
      "key0-%s-%s",
      formatdate("YYMMDDhhmmss", local.start_date),
      formatdate("YYMMDDhhmmss", local.expiration_date.key0)
    ), null)
    key1 = try(format(
      "key1-%s-%s",
      formatdate("YYMMDDhhmmss", local.start_date),
      formatdate("YYMMDDhhmmss", local.expiration_date.key1)
    ), null)
  }

  key = {
    # Coming from the default variables.tf
    days = try(local.password_policy.rotation_key0.days, null)
  }

  key0 = {
    days = try(local.password_policy.rotation_key0.days, null)
  }

  key1 = {
    days = try(local.password_policy.rotation_key1.days, null)
  }
}

resource "time_rotating" "key" {
  count         = lower(local.password_type) == "password" && try(var.settings.azuread_credential_policy_key, null) == null ? 1 : 0
  rotation_days = local.key.days
}

resource "random_password" "key" {
  count = lower(local.password_type) == "password" && try(var.settings.azuread_credential_policy_key, null) == null ? 1 : 0
  keepers = {
    frequency = time_rotating.key.0.id
  }
  length  = local.password_policy.length
  special = local.password_policy.special
  upper   = local.password_policy.upper
  number  = local.password_policy.number
}

resource "time_rotating" "key0" {
  count         = lower(local.password_type) == "password" && try(var.settings.azuread_credential_policy_key, null) != null ? 1 : 0
  rotation_days = local.key0.days
}

resource "random_password" "key0" {
  count = lower(local.password_type) == "password" && try(var.settings.azuread_credential_policy_key, null) != null ? 1 : 0
  keepers = {
    frequency = time_rotating.key0.0.id
  }
  length  = local.password_policy.length
  special = local.password_policy.special
  upper   = local.password_policy.upper
  number  = local.password_policy.number
}


resource "time_rotating" "key1" {
  count         = lower(local.password_type) == "password" && try(var.settings.azuread_credential_policy_key, null) != null ? 1 : 0
  rotation_days = local.key1.days
}

resource "random_password" "key1" {
  count = lower(local.password_type) == "password" && try(var.settings.azuread_credential_policy_key, null) != null ? 1 : 0
  keepers = {
    frequency = time_rotating.key1.0.id
  }
  length  = local.password_policy.length
  special = local.password_policy.special
  upper   = local.password_policy.upper
  number  = local.password_policy.number
}