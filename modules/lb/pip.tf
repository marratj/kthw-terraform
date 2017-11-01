resource "azurerm_public_ip" "pip" {
  name                         = "${var.resource_group_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"

  tags = "${var.azure_tags}"
}
