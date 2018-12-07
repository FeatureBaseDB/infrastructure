output "private_ip" {
  value = "${oci_core_instance.AgentInstance.private_ip}"
}

output "public_ip" {
  value = "${oci_core_instance.AgentInstance.public_ip}"
}
