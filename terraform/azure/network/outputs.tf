output "resource_group_id" {
  value = "${azurerm_resource_group.rg.id}"
}

output "security_group_id" {
  value = "${azurerm_network_security_group.security_group.id}"
}

output "subnet_ids" {
  value = ["${azurerm_subnet.subnets.*.id}"]
}
