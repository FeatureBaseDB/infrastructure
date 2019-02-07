variable "zone" {}
variable "project" {}
variable "region" {
    default = "us-central1"
}
variable "credentials_file" {
    default = "credentials.json"
}

variable "network_name" {
    default = "default"
}

variable "pilosa_machine_type" {
    default = "n1-standard-1"
}

variable "agent_machine_type" {
    default = "n1-standard-1"
}

variable "pilosa_image" {
    default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "agent_image" {
    default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "prefix_name" {
    default = "default"
}

variable "pilosa_cluster_size" {
    default = 3
}

variable "min_cpu_platform" {
  default = "Intel Skylake"
}
