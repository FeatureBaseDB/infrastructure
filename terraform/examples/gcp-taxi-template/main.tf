module "pilosa" {
  source = "../../gcp/pilosa"

  zone = "${var.zone}"
  credentials_file = "${var.credentials_file}"
  project = "${var.project}"
  region = "${var.region}"
  network_name = "${var.network_name}"
  machine_type = "${var.pilosa_machine_type}"
  image = "${var.pilosa_image}"
  prefix_name = "${var.prefix_name}"
  pilosa_cluster_size = "${var.pilosa_cluster_size}"
  ssh_public_key = "${var.ssh_public_key}"
  min_cpu_platform = "${var.min_cpu_platform}"
}

module "agent" {
  source = "../../gcp/agent"

  zone = "${var.zone}"
  credentials_file = "${var.credentials_file}"
  project = "${var.project}"
  region = "${var.region}"
  network_name = "${var.network_name}"
  machine_type = "${var.agent_machine_type}"
  image = "${var.agent_image}"
  prefix_name = "${var.prefix_name}"
  ssh_public_key = "${var.ssh_public_key}"
  min_cpu_platform = "${var.min_cpu_platform}"
}
