output "network_name" {
  value = "${google_compute_network.default.name}"
}
output "network_self_link" {
  value = "${google_compute_network.default.self_link}"
}
