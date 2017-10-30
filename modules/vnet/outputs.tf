output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "subnet_id" {
  value = "${azurerm_subnet.subnet.id}"
}
