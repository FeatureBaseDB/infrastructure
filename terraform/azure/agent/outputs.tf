output "private_ip" {
  value = "${azurerm_network_interface.agent_iface.private_ip_address}"
}

output "public_ip" {
  value = "${data.azurerm_public_ip.agent.ip_address}"
}
