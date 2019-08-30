resource "aws_instance" "agent" {
  //ami           = "ami-6dfe5010" // ubuntu
  ami = "ami-035be7bafff33b6b6" // Amazon Linux 2 AMI (HVM), SSD Volume Type (us-east N. Virginia)
  instance_type = "${var.agent_instance_type}"
  ebs_optimized = true
  placement_group = "${var.placement_group_id}"

  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id = "${var.subnet_id}"

  root_block_device {
    volume_type = "io1"
    volume_size = 200
    iops = 10000
  }

  tags = {
    Name = "${var.prefix_name}-agent"
  }
}

resource "aws_key_pair" "auth" {
  public_key = "${file(var.ssh_public_key)}"
}
