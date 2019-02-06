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

  # Oracle Linux 7.6 (CentOS-based)
  # From https://docs.cloud.oracle.com/iaas/images/image/7d31cb1d-f31f-450c-95c4-0539776c3dcf/
  default = {
    ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaafozx4cw5fgcnptx6ukgdjjfzvjb2365chtzprratabynb573wria"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaagbrvhganmn7awcr7plaaf5vhabmzhx763z5afiitswjwmzh7upna"
    uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaajwtut4l7fo3cvyraate6erdkyf2wdk5vpk6fp6ycng3dv2y3ymvq"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaawufnve5jxze4xf7orejupw5iq3pms6cuadzjc7klojix6vmk42va"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaadjnj3da72bztpxinmqpih62c2woscbp6l3wjn36by2cvmdhjub6a"
  }
}

variable "ssh_public_key" {}

variable "pilosa_cluster_size" {
  default = "1"
}

variable "prefix_name" {
  default = "default"
}
