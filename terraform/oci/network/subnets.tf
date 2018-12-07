resource "oci_core_subnet" "PilosaSubnetIAD0" {
  count = "${var.subnet_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "10.1.${count.index + 100}.0/24"
  display_name        = "PilosaSubnetIAD0${count.index + 100}"
  dns_label           = "iad0${count.index + 100}"
  security_list_ids   = ["${oci_core_security_list.PilosaSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_vcn.PilosaVCN.id}"
  route_table_id      = "${oci_core_route_table.PilosaRT.id}"
}

resource "oci_core_subnet" "PilosaSubnetIAD1" {
  count = "${var.subnet_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block          = "10.1.${count.index + 110}.0/24"
  display_name        = "PilosaSubnetIAD1${count.index + 110}"
  dns_label           = "iad1${count.index + 110}"
  security_list_ids   = ["${oci_core_security_list.PilosaSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_vcn.PilosaVCN.id}"
  route_table_id      = "${oci_core_route_table.PilosaRT.id}"
}

resource "oci_core_subnet" "PilosaSubnetIAD2" {
  count = "${var.subnet_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  cidr_block          = "10.1.${count.index + 120}.0/24"
  display_name        = "PilosaSubnetIAD2${count.index + 120}"
  dns_label           = "iad2${count.index + 120}"
  security_list_ids   = ["${oci_core_security_list.PilosaSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_vcn.PilosaVCN.id}"
  route_table_id      = "${oci_core_route_table.PilosaRT.id}"
}
