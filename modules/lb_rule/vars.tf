variable "resource_group_name" {
  description = "The name of the resource group the LB rule belongs to"
}

variable "loadbalancer_id" {
  description = "The Resource ID of the Load Balancer to which the rule is attached to"
}

variable "name" {
  description = "Name of the Load Balancing rule"
}

variable "protocol" {
  description = "The protocol which the rule applies to (Tcp/Udp)"
}

variable "frontend_port" {
  description = "The frontend port (ie. externally facing)"
}

variable "backend_port" {
  description = "The port on the backend services where the rule routes to"
}

variable "frontend_ip_configuration" {
  description = "The frontend IP configuration of the LB which the rule attaches to"
}

variable "backend_ip_address_pool" {
  description = "The backend IP address pool of the LB which the rule attaches to"
}
