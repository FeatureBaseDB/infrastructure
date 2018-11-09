output "private_ip" {
  value = "${oci_core_instance.OpsInstance.private_ip}"
}

output "public_ip" {
  value = "${oci_core_instance.OpsInstance.public_ip}"
}
