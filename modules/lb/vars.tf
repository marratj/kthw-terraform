variable "location" {
  description = "The Azure location where the Resource Group should be located"
}

variable "resource_group_name" {}

variable "azure_tags" {
  type = "map"

  default {
    environment = "KTHW"
  }
}
