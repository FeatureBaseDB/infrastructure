output "private_ips" {
  value = ["${module.pilosa.private_ips}"]
}

output "public_ips" {
  value = ["${module.pilosa.public_ips}"]
}

output "subnet_ocid" {
  value = "${module.network.subnet_ocids_iad0[0]}"
}
