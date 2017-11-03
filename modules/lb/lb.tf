resource "azurerm_lb" "lb" {
  name                = "${var.resource_group_name}-${var.lb_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.pip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "lbpool" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "${var.lb_name}"
}

resource "azurerm_lb_probe" "ssh" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "ssh" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  name                           = "SSH"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "${azurerm_lb.lb.frontend_ip_configuration.0.name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lbpool.id}"
}
