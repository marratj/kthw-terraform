variable "location" {
  description = "The Azure location where the Resource Group should be located"
}

variable "vnet_name" {}

variable "vnet_address_space" {
  type = "list"
}

variable "azure_tags" {
  type = "map"

  default {
    environment = "KTHW"
  }
}
