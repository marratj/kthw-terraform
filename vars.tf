variable "location" {
  description = "The Azure location where the Resource Group should be located"
  default     = "westeurope"
}

variable "worker_ip_addresses" {
  description = "The list of private IP addresses for the worker nodes"
  type        = "list"
}

variable "master_ip_addresses" {
  description = "The list of private IP addresses for the master nodes"
  type        = "list"
}
