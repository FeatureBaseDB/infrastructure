resource "oci_core_instance" "PilosaInstance" {
  count               = "${var.pilosa_cluster_size}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "pilosa${count.index}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pilosa${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${file("${var.ssh_public_key}")}"
    instance_index = "${count.index}"
  }

  timeouts {
    create = "60m"
  }
}