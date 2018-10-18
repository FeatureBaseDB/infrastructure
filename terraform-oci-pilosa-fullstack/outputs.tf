output "private_ips" {
  value = ["${module.pilosa.private_ips}"]
}

output "public_ips" {
  value = ["${module.pilosa.public_ips}"]
}

output "subnet_ocid" {
  value = "${oci_core_subnet.PilosaSubnet.id}"
}
