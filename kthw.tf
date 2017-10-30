module "vnet" {
  source = "modules/vnet"

  location = "${var.location}"

  vnet_name          = "kthw"
  vnet_address_space = ["10.240.0.0/24"]
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
}
