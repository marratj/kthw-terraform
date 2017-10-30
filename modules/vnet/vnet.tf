resource "azurerm_resource_group" "rg" {
  name     = "${var.vnet_name}-rg"
  location = "${var.location}"

  tags = "${var.azure_tags}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}-vnet"
  address_space       = "${var.vnet_address_space}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags = "${var.azure_tags}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.vnet_name}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.vnet_address_space[0]}"

  network_security_group_id = "${azurerm_network_security_group.sg.id}"
}

resource "azurerm_network_security_group" "sg" {
  name                = "${var.vnet_name}-sg"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags = "${var.azure_tags}"
}

resource "azurerm_network_security_rule" "ssh-in" {
  name                        = "ssh-in"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sg.name}"
}

resource "azurerm_network_security_rule" "https-in" {
  name                        = "https-in"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sg.name}"
}
