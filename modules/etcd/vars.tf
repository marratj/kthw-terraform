variable "kubernetes_certs_null_ids" {
  type = "list"
  description = "The ID of the kubernetes apiserver certificate null resource id for dependency"
}

variable "ca_cert_null_ids" {
  type = "list"
  description = "The ID of the CA certificate null resource id for dependency"
}

variable "apiserver_node_names" {
  type        = "list"
  description = "The list of nodes that will have an apiserver certificate generated"
}

variable "apiserver_public_ip" {
  type        = "string"
  description = "The public IP address for the apiserver certificate"
}

variable "node_user" {
  description = "The node user name to use for provision the certificates to the nodes"
}
