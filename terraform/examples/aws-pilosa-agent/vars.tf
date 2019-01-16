variable "pilosa_cluster_size" {
  description = "Number of Pilosa instances to launch"
  type = "string"
  default = "3"
}

variable "pilosa_instance_type" {
  default = "r4.2xlarge"
}

variable "agent_instance_type" {
  default = "c5.large"
}

variable "prefix_name" {
  description = "Name of your cluster and agents - used in tags and (hopefully) hostnames"
  default = "default"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "security_group_id" {
}

variable "subnet_id" {
}

variable "placement_group_id" {
}
