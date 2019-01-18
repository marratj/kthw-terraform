variable "kubelet_node_names" {
  type        = "list"
  description = "The list of nodes that need to have kubeconfig files copied over"
}

variable "apiserver_node_names" {
  type        = "list"
  description = "The list of apiserver nodes that need to have kubeconfig files copied over"
}

variable "apiserver_public_ip" {
  type        = "string"
  description = "The public IP address for the apiserver certificate"
}

variable "node_user" {
  description = "The node user name to use for provision the certificates to the nodes"
}

variable "kubelet_count" {
  description = "The count of worker nodes to have for the kubelet configs"
}

variable "kube_ca_crt_pem" {
  description = "The CA certificate file"
}

variable "admin_crt_pem" {
  description = "The admin certificate data"
}

variable "admin_key_pem" {
  description = "The admin key data"
}

variable "kube-proxy_crt_pem" {
  description = "The kube-proxy certificate data"
}

variable "kube-proxy_key_pem" {
  description = "The kube-proxy key data"
}

variable "kube-scheduler_crt_pem" {
  description = "The kube-scheduler certificate data"
}

variable "kube-scheduler_key_pem" {
  description = "The kube-scheduler key data"
}

variable "kube-controller-manager_crt_pem" {
  description = "The kube-controller-manager certificate data"
}

variable "kube-controller-manager_key_pem" {
  description = "The kube-controller-manager key data"
}

variable "kubelet_crt_pems" {
  type        = "list"
  description = "The list of kubelet certificate pems"
}

variable "kubelet_key_pems" {
  type        = "list"
  description = "The list of kubelet key pems"
}
