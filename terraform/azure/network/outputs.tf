output "resource_group_id" {
  value = "${azurerm_resource_group.rg.id}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "resource_group_location" {
  value = "${azurerm_resource_group.rg.location}"
}

output "security_group_id" {
  value = "${azurerm_network_security_group.security_group.id}"
}

output "subnet_ids" {
  value = "${azurerm_subnet.subnets.*.id}"
}
