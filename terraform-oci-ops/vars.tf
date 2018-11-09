variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}

variable "availability_domain" {
  default = "1"
}

variable "vcn_ocid" {}
variable "route_table_ocid" {}

variable "instance_shape" {
  default = "VM.Standard2.8"
}

# from https://docs.cloud.oracle.com/iaas/images/ubuntu-1804/
variable "instance_image_ocid" {
  type = "map"

  default = {
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaahmblavdr6elu7gmt3jqtjcu2uitlzieb4jv3hh675sjqwadxv5pa"
  }
}

variable "ssh_public_key" {}
