variable "zone" {}
variable "project" {}
variable "region" {
    default = "us-central1"
}
variable "prefix_name" {
    default = "default"
}
variable "credentials_file" {
    default = "credentials.json"
}

variable "name" {
    default = "network"
}
