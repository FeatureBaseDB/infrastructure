module "pilosa" {
  source = "../../aws/pilosa"

  prefix_name = "${var.prefix_name}"
  subnet_id = "${var.subnet_id}"
  ssh_public_key = "${var.ssh_public_key}"
  security_group_id = "${var.security_group_id}"
  placement_group_id = "${var.placement_group_id}"
  pilosa_instance_type = "${var.pilosa_instance_type}"
  pilosa_cluster_size = "${var.pilosa_cluster_size}"
}

module "agent" {
  source = "../../aws/agent"

  prefix_name = "${var.prefix_name}"
  subnet_id = "${var.subnet_id}"
  ssh_public_key = "${var.ssh_public_key}"
  security_group_id = "${var.security_group_id}"
  placement_group_id = "${var.placement_group_id}"
  agent_instance_type = "${var.agent_instance_type}"
}

