resource "google_compute_firewall" "allow-ssh-web" {
  name    = "${var.prefix_name}-allow-ssh-web"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "8000"]
  }
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${var.prefix_name}-allow-internal"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    "10.0.0.0/8"
  ]
}


resource "google_compute_network" "default" {
  name = "${var.prefix_name}-network"
}
