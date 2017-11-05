output "public_ip_address" {
  value = "${azurerm_public_ip.pip.ip_address}"
}

output "lb_backend_pool" {
  value = "${azurerm_lb_backend_address_pool.lbpool.id}"
}

output "lb_id" {
  value = "${azurerm_lb.lb.id}"
}

output "frontend_ip_config" {
  value = "${azurerm_lb.lb.frontend_ip_configuration.0.name}"
}
