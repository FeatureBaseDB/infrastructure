resource "oci_core_instance" "AgentInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.prefix_name}-agent"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "${var.prefix_name}-agent"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  metadata = {
    ssh_authorized_keys = "${file("${var.ssh_public_key}")}"
  }

  timeouts {
    create = "60m"
  }
}
