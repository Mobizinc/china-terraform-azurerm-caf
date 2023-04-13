variable "monthly_retention" {
  description = "The monthly retention policy for an LTR backup in an ISO 8601 format. Valid value is between 1 to 520 weeks GP_Gen5, GP_G8IM, GP_G8IH, BC_Gen5, BC_G8IM, BC_G8IH"

  validation {
    condition = contains(
      [
        "P1Y", "P1Y", "P1Y", "P30D"
      ],
      var.monthly_retention
    )
    error_message = format("Not supported value: '%s'. \nAdjust your configuration file with a supported value: %s",
      var.monthly_retention,
      join(", ",
        [
          "P1Y", "P1Y", "P1Y", "P30D"
        ]
      )
    )
  }
}
output "monthly_retention" {
  value = var.monthly_retention
}
