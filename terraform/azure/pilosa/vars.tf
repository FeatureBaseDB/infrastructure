variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "prefix_name" {
  default = "test"
}

variable "resource_group_location" {
  default = "South Central US"
}

variable "pubkey_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pilosa_cluster_size" {
  description = "Number of Pilosa nodes."
  type = "string"
  default = "3"
}

variable "pilosa_vm_size" {
  description = "Azure VM size to use for Pilosa nodes."
  type = "string"
  default = "Standard_D4s_v3" # 4vcpu 16GB
}
