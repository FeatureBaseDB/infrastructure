output "private_ip" {
  value = "${oci_core_instance.CodespeedInstance.private_ip}"
}

output "public_ip" {
  value = "${oci_core_instance.CodespeedInstance.public_ip}"
}
