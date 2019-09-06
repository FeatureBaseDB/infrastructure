output "pilosa_private_ips" {
  value = "${oci_core_instance.PilosaInstance.*.private_ip}"
}

output "pilosa_public_ips" {
  value = "${oci_core_instance.PilosaInstance.*.public_ip}"
}
