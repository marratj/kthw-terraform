module "vnet" {
  source = "modules/vnet"

  location = "${var.location}"

  vnet_name          = "kthw"
  vnet_address_space = ["10.240.0.0/24"]
}

module "lb_masters" {
  source = "modules/lb"

  resource_group_name = "${module.vnet.resource_group_name}"
  location            = "${var.location}"

  lb_name = "lb_masters"
}

module "master_ssh_inbound" {
  source              = "modules/lb_rule"
  resource_group_name = "${module.vnet.resource_group_name}"

  loadbalancer_id           = "${module.lb_masters.lb_id}"
  name                      = "ssh"
  protocol                  = "Tcp"
  frontend_port             = 22
  backend_port              = 22
  frontend_ip_configuration = "${module.lb_masters.frontend_ip_config}"
  backend_ip_address_pool   = "${module.lb_masters.lb_backend_pool}"
}

module "lb_workers" {
  source = "modules/lb"

  resource_group_name = "${module.vnet.resource_group_name}"
  location            = "${var.location}"

  lb_name = "lb_workers"
}

module "masters" {
  source = "modules/vms"

  vm_prefix = "kthw-master"
  vm_count  = "${var.master_count}"
  vm_size   = "Standard_D1_v2"

  subnet_id           = "${module.vnet.subnet_id}"
  resource_group_name = "${module.vnet.resource_group_name}"

  location = "${var.location}"

  private_ip_addresses = "${var.master_ip_addresses}"
  lb_backend_pool      = "${module.lb_masters.lb_backend_pool}"

  username = "${var.node_user}"
  ssh_key  = "${var.node_ssh_key}"

  public_ip = "${module.lb_masters.public_ip_address}"

  consul_agent_type = "server"
}

module "workers" {
  source = "modules/vms"

  vm_prefix = "kthw-worker"
  vm_count  = "${var.worker_count}"
  vm_size   = "Standard_D1_v2"

  subnet_id           = "${module.vnet.subnet_id}"
  resource_group_name = "${module.vnet.resource_group_name}"

  location = "${var.location}"

  private_ip_addresses = "${var.worker_ip_addresses}"
  lb_backend_pool      = "${module.lb_workers.lb_backend_pool}"

  username = "${var.node_user}"
  ssh_key  = "${var.node_ssh_key}"

  public_ip = "${module.lb_masters.public_ip_address}"
}

module "pki" {
  source = "modules/pki"

  kubelet_node_names   = "${module.workers.names}"
  apiserver_node_names = "${module.masters.names}"

  kubelet_node_ips = "${module.workers.private_ip_addresses}"

  apiserver_master_ips = "${module.masters.private_ip_addresses}"
  apiserver_public_ip  = "${module.lb_masters.public_ip_address}"

  node_user = "${var.node_user}"
}

module "kubeconfig" {
  source = "modules/kubeconfig"

  kubelet_node_names   = "${module.workers.names}"
  apiserver_node_names = "${module.masters.names}"
  kubelet_count        = "${var.worker_count}"
  apiserver_public_ip  = "${module.lb_masters.public_ip_address}"
  node_user            = "${var.node_user}"

  kubelet_crt_pems                = "${module.pki.kubelet_crt_pems}"
  kubelet_key_pems                = "${module.pki.kubelet_key_pems}"
  kube-proxy_crt_pem              = "${module.pki.kube-proxy_crt_pem}"
  kube-proxy_key_pem              = "${module.pki.kube-proxy_key_pem}"
  admin_crt_pem                   = "${module.pki.admin_crt_pem}"
  admin_key_pem                   = "${module.pki.admin_key_pem}"
  kube-scheduler_crt_pem          = "${module.pki.kube-scheduler_crt_pem}"
  kube-scheduler_key_pem          = "${module.pki.kube-scheduler_key_pem}"
  kube-controller-manager_crt_pem = "${module.pki.kube-controller-manager_crt_pem}"
  kube-controller-manager_key_pem = "${module.pki.kube-controller-manager_key_pem}"
  kube_ca_crt_pem                 = "${module.pki.kube_ca_crt_pem}"
}

module "encryption_config" {
  source               = "modules/encryption_config"
  apiserver_node_names = "${module.masters.names}"
  apiserver_public_ip  = "${module.lb_masters.public_ip_address}"

  node_user = "${var.node_user}"
}
