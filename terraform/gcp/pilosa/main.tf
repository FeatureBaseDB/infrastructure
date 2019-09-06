resource "google_compute_instance" "pilosa" {
  name         = "${var.prefix_name}-pilosa${count.index}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  min_cpu_platform = "${var.min_cpu_platform}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
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

  count = "${var.pilosa_cluster_size}"
}
