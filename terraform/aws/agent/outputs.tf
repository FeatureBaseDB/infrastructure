output "public_ip" {
  value = "${aws_instance.agent.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.agent.private_ip}"
}
