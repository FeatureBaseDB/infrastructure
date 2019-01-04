output "public_ips" {
  value = ["${data.azurerm_public_ip.pilosa.*.ip_address}"]
}
