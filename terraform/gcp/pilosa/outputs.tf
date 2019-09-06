output "pilosa_public_ips" {
  value = "${google_compute_instance.pilosa.*.network_interface.0.access_config.0.nat_ip}"
}

output "pilosa_private_ips" {
  value = "${google_compute_instance.pilosa.*.network_interface.0.network_ip}"
}
