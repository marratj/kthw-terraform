resource "azurerm_resource_group" "kthw-rg" {
  name     = "kthw-rg"
  location = "westeurope"

  tags {
    environment = "KTHW"
  }
}

resource "azurerm_virtual_network" "kthw-vnet" {
  name                = "kthw-vnet"
  address_space       = ["10.240.0.0/24"]
  location            = "${azurerm_resource_group.kthw-rg.location}"
  resource_group_name = "${azurerm_resource_group.kthw-rg.name}"

  tags {
    environment = "KTHW"
  }
}

resource "azurerm_subnet" "kthw-subnet1" {
  name                 = "kthw-subnet1"
  resource_group_name  = "${azurerm_resource_group.kthw-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.kthw-vnet.name}"
  address_prefix       = "10.240.0.0/24"
}

resource "azurerm_network_security_group" "kthw-sg" {
  name                = "kthw-sg"
  location            = "${azurerm_resource_group.kthw-rg.location}"
  resource_group_name = "${azurerm_resource_group.kthw-rg.name}"

  tags {
    environment = "KTHW"
  }
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
  resource_group_name         = "${azurerm_resource_group.kthw-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.kthw-sg.name}"
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
  resource_group_name         = "${azurerm_resource_group.kthw-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.kthw-sg.name}"
}
