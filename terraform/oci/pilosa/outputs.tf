output "private_ips" {
  value = ["${oci_core_instance.PilosaInstance.*.private_ip}"]
}

output "public_ips" {
  value = ["${oci_core_instance.PilosaInstance.*.public_ip}"]
}
