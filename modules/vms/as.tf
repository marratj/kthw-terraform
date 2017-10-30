resource "azurerm_availability_set" "as" {
  name                = "${var.vm_prefix}-as"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  managed = true

  tags = "${var.azure_tags}"
}
