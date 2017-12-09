variable "kubelet_node_names" {
  type        = "list"
  description = "The list of nodes that will have a kubelet client certificate generated"
}

variable "apiserver_public_ip" {
  type        = "string"
  description = "The public IP address for the apiserver certificate"
}
