resource "google_compute_instance" "agent" {
  name         = "${var.prefix_name}-agent"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  min_cpu_platform = "${var.min_cpu_platform}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
      size = "${var.agent_disk_size_gb}"
    }
  }

  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "${var.network_name}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    sshKeys = "ubuntu:${file("${pathexpand("${var.ssh_public_key}")}")}"
  }
}
