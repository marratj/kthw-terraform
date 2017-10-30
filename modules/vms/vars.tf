variable "location" {
  description = "The Azure location where the Resource Group should be located"
}

variable "vm_prefix" {}

variable "vm_count" {}

variable "vm_size" {}

variable "subnet_id" {}

variable "resource_group_name" {}

variable "private_ip_addresses" {
  type = "list"
}

variable "azure_tags" {
  type = "map"

  default {
    environment = "KTHW"
  }
}
