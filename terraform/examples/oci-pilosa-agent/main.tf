#terraform {
#  backend "s3" {
#    bucket = "pilosa-terraform"
#    key    = "cody/oci-pilosa-agent"
#    region = "us-east-1"
#  }
#}

module "pilosa" {
  source = "../../oci/pilosa"

  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"

  compartment_ocid = "${var.compartment_ocid}"

  subnet_ocid = "${var.subnet_ocid}"

  ssh_public_key = "${var.ssh_public_key}"
  availability_domain = "${var.availability_domain}"
  instance_shape = "${var.instance_shape}"
  instance_image_ocid = "${var.instance_image_ocid}"
  pilosa_cluster_size = "${var.pilosa_cluster_size}"
  prefix_name = "${var.prefix_name}"
}

module "agent" {
  source = "../../oci/agent"

  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"

  compartment_ocid = "${var.compartment_ocid}"

  subnet_ocid = "${var.subnet_ocid}"

  ssh_public_key = "${var.ssh_public_key}"
  availability_domain = "${var.availability_domain}"
  instance_shape = "${var.agent_instance_shape}"
  instance_image_ocid = "${var.instance_image_ocid}"
  prefix_name = "${var.prefix_name}"
}
