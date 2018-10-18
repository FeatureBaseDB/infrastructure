module "network" {
  source = "../terraform-oci-network"

  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"

  compartment_ocid = "${var.compartment_ocid}"
}

resource "oci_core_security_list" "PilosaSecurityList" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${module.network.vcn_ocid}"
  display_name   = "PilosaSecurityList"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"        // udp
    stateless   = true
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "10.1.0.0/16"
    stateless = false

    tcp_options {
      "min" = 10101
      "max" = 10101
    }
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "10.1.0.0/16"
    stateless = false

    tcp_options {
      "min" = 14000
      "max" = 14000
    }
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      "type" = 3
      "code" = 4
    }
  }
}

resource "oci_core_subnet" "PilosaSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block          = "10.1.101.0/24"
  display_name        = "PilosaSubnet"
  dns_label           = "pilosasubnet"
  security_list_ids   = ["${oci_core_security_list.PilosaSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${module.network.vcn_ocid}"
  route_table_id      = "${module.network.route_table_ocid}"
}
