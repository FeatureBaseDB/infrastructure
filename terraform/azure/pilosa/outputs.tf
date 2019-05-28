output "pilosa_private_ips" {
  value = "${azurerm_network_interface.pilosa_iface.*.private_ip_address}"
}

output "pilosa_public_ips" {
  value = "${data.azurerm_public_ip.pilosa.*.ip_address}"
}
