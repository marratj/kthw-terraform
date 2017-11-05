resource "azurerm_lb_probe" "probe" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${var.loadbalancer_id}"
  name                = "${var.backend_port}-probe"
  port                = "${var.backend_port}"
}

resource "azurerm_lb_rule" "ssh" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${var.loadbalancer_id}"
  name                           = "${var.name}"
  protocol                       = "${var.protocol}"
  frontend_port                  = "${var.frontend_port}"
  backend_port                   = "${var.backend_port}"
  frontend_ip_configuration_name = "${var.frontend_ip_configuration}"
  backend_address_pool_id        = "${var.backend_ip_address_pool}"
}
