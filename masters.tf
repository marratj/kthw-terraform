resource "azurerm_network_interface" "kthw-master-nics" {
  name                = "kthw-master-${count.index}-nic"
  location            = "${azurerm_resource_group.kthw-rg.location}"
  resource_group_name = "${azurerm_resource_group.kthw-rg.name}"

  count = 3

  enable_ip_forwarding = true

  internal_dns_name_label = "kthw-master-${count.index}"

  ip_configuration {
    name                          = "kthw-master-${count.index}-ip-config"
    subnet_id                     = "${azurerm_subnet.kthw-subnet1.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.240.0.2${count.index}"
  }
}

resource "azurerm_virtual_machine" "kthw-masters" {
  name                  = "kthw-master-${count.index}"
  location              = "${azurerm_resource_group.kthw-rg.location}"
  resource_group_name   = "${azurerm_resource_group.kthw-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.kthw-master-nics.*.id[count.index]}"]
  vm_size               = "Standard_B1ms"

  count = 3

  availability_set_id = "${azurerm_availability_set.kthw-master-as.id}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "kthw-master-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 200
  }

  # Optional data disks

  os_profile {
    computer_name  = "kthw-master-${count.index}"
    admin_username = "kubeheinz"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/kubeheinz/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgc0NiIoVMov1LH7NOpjrYBrzgdEVt/t4DmYO2wNCYIInBYrQvxr4NalO7tQhyowUqKYxKf7WRyXUkV0q8GnThsFz+g0hs4L93OVFmPc/GRlVljSXiK+/okqE2KGJVZVg5PRL/Mpi0Pg9zifcDOHDDyvap7AtSRpTWD50eSSRwuN1cKoWITrIaAWDtuo1pkfuzsb56aipA0rgxXHaDv2ODlTjnAjZ83qGNt1A7U6pEDpqUZ+ttIHoVP9qkputn4KUgxs6M6ycMIiA2OdJWveHGeyD/vdmE9Sc/3Po8XnQl6H5p6C+pu9wiXp0YPUcRp3R7J1dwRzQYHKBh31XUS93N marrat@MARRAT-PC"
    }
  }
  tags {
    environment = "KTHW"
  }
}
