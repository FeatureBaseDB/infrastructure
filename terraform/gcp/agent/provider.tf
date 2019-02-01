provider "google" {
  credentials = "${var.credentials_file}"
  project     = "${var.project}"
  region      = "${var.region}"
}
