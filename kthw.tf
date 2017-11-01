module "vnet" {
  source = "modules/vnet"

  location = "${var.location}"

  vnet_name          = "kthw"
  vnet_address_space = ["10.240.0.0/24"]
}

module "lb" {
  source = "modules/lb"

  resource_group_name = "${module.vnet.resource_group_name}"
  location            = "${var.location}"
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
}

module "workers" {
  source = "modules/vms"

  vm_prefix = "kthw-worker"
  vm_count  = "${var.master_count}"
  vm_size   = "Standard_B1ms"

  subnet_id           = "${module.vnet.subnet_id}"
  resource_group_name = "${module.vnet.resource_group_name}"

  location = "${var.location}"

  private_ip_addresses = "${var.worker_ip_addresses}"
}

module "pki" {
  source = "modules/pki"

  kubelet_node_names = "${module.workers.names}"

  #kubelet_node_ips = "${var.worker_ip_addresses}"
  kubelet_node_ips = "${module.workers.private_ip_addresses}"

  apiserver_master_ips = "${module.masters.private_ip_addresses}"
  apiserver_public_ip  = "${module.lb.public_ip_address}"
}
