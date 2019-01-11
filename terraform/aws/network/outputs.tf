output "security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "subnet_ids" {
  value = ["${aws_subnet.default.*.id}"]
}

output "placement_group_id" {
  value = "${aws_placement_group.pg.id}"
}
