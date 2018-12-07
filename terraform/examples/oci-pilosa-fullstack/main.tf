module "pilosa" {
  source = "../../oci/pilosa"

  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"

  compartment_ocid = "${var.compartment_ocid}"

  subnet_ocid = "${module.network.subnet_ocids_iad0[0]}"

  ssh_public_key = "${var.ssh_public_key}"
  availability_domain = "${var.availability_domain}"
  instance_shape = "${var.instance_shape}"
  instance_image_ocid = "${var.instance_image_ocid}"
  pilosa_cluster_size = "${var.pilosa_cluster_size}"
}
