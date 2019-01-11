output "pilosa_public_ips" {
  value = "${aws_instance.pilosa.*.public_ip}"
}

output "pilosa_private_ips" {
  value = "${aws_instance.pilosa.*.private_ip}"
}
