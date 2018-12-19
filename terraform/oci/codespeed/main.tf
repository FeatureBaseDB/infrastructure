data "oci_core_volume_backup_policies" "GoldBackupPolicy" {
  filter {
    name   = "display_name"
    values = ["gold"]
  }
}

resource "oci_core_volume_backup_policy_assignment" "CodespeedBackupPolicyAssignment" {
  asset_id  = "${oci_core_instance.CodespeedInstance.boot_volume_id}"
  policy_id = "${data.oci_core_volume_backup_policies.GoldBackupPolicy.volume_backup_policies.0.id}"
}

resource "oci_core_instance" "CodespeedInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "codespeed"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.CodespeedSubnet.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "codespeed"
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

resource "oci_core_subnet" "CodespeedSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block          = "10.1.201.0/24"
  display_name        = "CodespeedSubnet"
  dns_label           = "codespeed"
  security_list_ids   = ["${oci_core_security_list.CodespeedSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${var.vcn_ocid}"
  route_table_id      = "${var.route_table_ocid}"
}
