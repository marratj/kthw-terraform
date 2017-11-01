output "names" {
  value = "${azurerm_virtual_machine.vm.*.name}"
}

output "private_ip_addresses" {
  value = "${azurerm_network_interface.nic.*.private_ip_address}"
}
