resource "azurerm_availability_set" "kthw-master-as" {
  name                = "kthw-master-as"
  location            = "${azurerm_resource_group.kthw-rg.location}"
  resource_group_name = "${azurerm_resource_group.kthw-rg.name}"

  managed = true

  tags {
    environment = "KTHW"
  }
}

resource "azurerm_availability_set" "kthw-worker-as" {
  name                = "kthw-worker-as"
  location            = "${azurerm_resource_group.kthw-rg.location}"
  resource_group_name = "${azurerm_resource_group.kthw-rg.name}"

  managed = true

  tags {
    environment = "KTHW"
  }
}
