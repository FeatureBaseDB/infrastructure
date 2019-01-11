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

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "agent_vm_size" {
  description = "Azure VM size to use for agent."
  type = "string"
  default = "Standard_D4s_v3" # 4vcpu 16GB
}

variable "subnet_id" {
}

variable "resource_group_name" {
}
