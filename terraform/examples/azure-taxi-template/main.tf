module "pilosa" {
  source = "../../azure/pilosa"

  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
  resource_group_location = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  prefix_name = "${var.prefix_name}"
  subnet_id = "${var.subnet_id}"
  ssh_public_key = "${var.ssh_public_key}"
  pilosa_vm_size = "${var.pilosa_vm_size}"
  pilosa_cluster_size = "${var.pilosa_cluster_size}"
}

module "agent" {
  source = "../../azure/agent"

  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
  resource_group_location = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  prefix_name = "${var.prefix_name}"
  subnet_id = "${var.subnet_id}"
  ssh_public_key = "${var.ssh_public_key}"
  agent_vm_size = "${var.agent_vm_size}"
}

