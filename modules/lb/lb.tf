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
