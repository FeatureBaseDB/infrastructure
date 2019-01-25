resource "google_compute_instance" "agent" {
  name         = "${var.prefix_name}-agent"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    sshKeys = "ubuntu:${file("${pathexpand("${var.ssh_public_key}")}")}"
  }
}
