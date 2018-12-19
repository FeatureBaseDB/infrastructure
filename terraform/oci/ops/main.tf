resource "oci_core_instance" "OpsInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ops"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.OpsSubnet.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "ops"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${file("${var.ssh_public_key}")}"
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_subnet" "OpsSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block          = "10.1.200.0/24"
  display_name        = "OpsSubnet"
  dns_label           = "ops"
  security_list_ids   = ["${oci_core_security_list.OpsSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${var.vcn_ocid}"
  route_table_id      = "${var.route_table_ocid}"
}
