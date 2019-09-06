resource "oci_core_security_list" "PilosaSecurityList" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_vcn.PilosaVCN.id}"
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
      min = 10101
      max = 10101
    }
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "10.1.0.0/16"
    stateless = false

    tcp_options {
      min = 14000
      max = 14000
    }
  }

  ingress_security_rules {
    protocol  = "17"         // udp
    source    = "10.1.0.0/16"
    stateless = false

    udp_options {
      min = 14000
      max = 14000
    }
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 8000
      max = 8000
    }
  }

  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 8000
      max = 8000
    }
  }
}
