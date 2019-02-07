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

variable "agent_instance_shape" {
  default = "VM.Standard1.1"
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    # Oracle Linux 7.6 (CentOS) from https://docs.cloud.oracle.com/iaas/images/image/d8b26ac8-6fa0-4d37-973f-39df64a51aa9/
    "eu-frankfurt-1"= "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaamrvusixu33rzvgvjpfjflwkjeyfwnnoyoefoqxnmttds5vukj4vq"
    "us-ashburn-1"= "ocid1.image.oc1.iad.aaaaaaaawiur3bi46qsb6egmfqnfhsn66kj74bnvnfxrr7o72wiyuhzy2fba"
    "uk-london-1"= "ocid1.image.oc1.uk-london-1.aaaaaaaaannfmrswpgevhcp3de4ngip4vcxi7culiimgm7mi4npiuxwweqrq"
    "us-phoenix-1"= "ocid1.image.oc1.phx.aaaaaaaaklifrcpkhjgszalaoitdshyxbxog3wm5ccol55m2apw3fg3mjndq"
  }
}

variable "ssh_public_key" {}

variable "pilosa_cluster_size" {
  default = "1"
}

variable "prefix_name" {
  default = "default"
}
