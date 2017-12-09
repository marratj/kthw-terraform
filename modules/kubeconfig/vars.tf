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

variable "kubelet_crt_files" {
  type        = "list"
  description = "The list of kubelet certificate files"
}

variable "kubelet_key_files" {
  type        = "list"
  description = "The list of kubelet key files"
}

variable "kube-proxy_crt_file" {
  description = "The kube-proxy certificate file"
}

variable "kube-proxy_key_file" {
  description = "The kube-proxy key file"
}

variable "ca_crt_file" {
  description = "The CA certificate file"
}
