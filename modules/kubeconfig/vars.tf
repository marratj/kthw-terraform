variable "kubelet_node_names" {
  type        = "list"
  description = "The list of nodes that will have a kubelet client certificate generated"
}

variable "apiserver_public_ip" {
  type        = "string"
  description = "The public IP address for the apiserver certificate"
}

variable "node_user" {
  description = "The node user name to use for provision the certificates to the nodes"
}

variable "kube_ca_crt_pem" {
  description = "The CA certificate file"
}

variable "kube-proxy_crt_pem" {
  description = "The kube-proxy certificate data"
}

variable "kube-proxy_key_pem" {
  description = "The kube-proxy key data"
}

variable "kubelet_crt_pems" {
  type        = "list"
  description = "The list of kubelet certificate pems"
}

variable "kubelet_key_pems" {
  type        = "list"
  description = "The list of kubelet key pems"
}
