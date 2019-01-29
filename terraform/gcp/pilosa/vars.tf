variable "zone" {}
variable "project" {}
variable "region" {
    default = "n1-standard-1"
}
variable "credentials_file" {
    default = "credentials.json"
}

variable "machine_type" {
    default = "n1-standard-1"
}

variable "image" {
    default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "ssh_public_key" {}

variable "prefix_name" {
    default = "default"
}

variable "pilosa_cluster_size" {
    default = 3
}
