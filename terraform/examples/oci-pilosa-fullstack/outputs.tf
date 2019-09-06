output "pilosa_private_ips" {
  value = "${module.pilosa.pilosa_private_ips}"
}

output "pilosa_public_ips" {
  value = "${module.pilosa.pilosa_public_ips}"
}

output "subnet_ocid" {
  value = "${module.network.subnet_ocids_iad0[0]}"
}
