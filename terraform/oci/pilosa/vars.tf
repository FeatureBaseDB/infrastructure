variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}

variable "availability_domain" {
  default = "1"
}

variable "subnet_ocid" {}

variable "instance_shape" {
  default = "VM.Standard1.1"
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaahmblavdr6elu7gmt3jqtjcu2uitlzieb4jv3hh675sjqwadxv5pa"
  }
}

variable "ssh_public_key" {}

variable "pilosa_cluster_size" {
  default = "1"
}

variable "hostname_prefix" {
  default = "default"
}
