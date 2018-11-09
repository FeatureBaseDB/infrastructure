resource "oci_core_vcn" "PilosaVCN" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "PilosaVCN"
  dns_label      = "pilosa"
}

resource "oci_core_internet_gateway" "PilosaIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "PilosaIG"
  vcn_id         = "${oci_core_vcn.PilosaVCN.id}"
}

resource "oci_core_route_table" "PilosaRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_vcn.PilosaVCN.id}"
  display_name   = "PilosaRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.PilosaIG.id}"
  }
}
