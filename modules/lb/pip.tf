resource "azurerm_public_ip" "pip" {
  name                         = "${var.resource_group_name}-${var.lb_name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"

  tags = "${var.azure_tags}"
}
