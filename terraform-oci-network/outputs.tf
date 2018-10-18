output "vcn_ocid" {
  value = "${oci_core_vcn.PilosaVCN.id}"
}
output "route_table_ocid" {
  value = "${oci_core_route_table.PilosaRT.id}"
}
