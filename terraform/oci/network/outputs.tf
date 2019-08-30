output "vcn_ocid" {
  value = "${oci_core_vcn.PilosaVCN.id}"
}
output "route_table_ocid" {
  value = "${oci_core_route_table.PilosaRT.id}"
}
output "subnet_ocids_iad0" {
  value = "${oci_core_subnet.PilosaSubnetIAD0.*.id}"
}
output "subnet_ocids_iad1" {
  value = "${oci_core_subnet.PilosaSubnetIAD1.*.id}"
}
output "subnet_ocids_iad2" {
  value = "${oci_core_subnet.PilosaSubnetIAD2.*.id}"
}
