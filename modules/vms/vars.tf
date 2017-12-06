variable "location" {
  description = "The Azure location where the Resource Group should be located"
}

variable "vm_prefix" {
  description = "The prefix to use for all the VM names"
}

variable "vm_count" {
  description = "The count of VMs to create"
}

variable "vm_size" {
  description = "The instance size of the VMs to create"
}

variable "lb_backend_pool" {
  default     = ""
  description = "The Load Balancer backend pool to attach the VM NICs to"
}

variable "subnet_id" {
  description = "The subnet ID to place the VM NICs into"
}

variable "resource_group_name" {}

variable "ssh_key" {
  description = "The public SSH key to provision to the instance user"
}

variable "private_ip_addresses" {
  type        = "list"
  description = "A list of private IP addresses that are attached in that order to the VM NICs"
}

variable "username" {}

variable "azure_tags" {
  type = "map"

  default {
    environment = "KTHW"
  }
}

variable "public_ip" {
  type        = "string"
  description = "The public IP address for the consul privisioning"
}

variable "consul_agent_type" {
  type        = "string"
  description = "The type of the Consul agent to deploy (server or client)"
  default     = "client"
}
