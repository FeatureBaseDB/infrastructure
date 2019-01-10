resource "aws_placement_group" "pilosa-pg" {
  name     = "${var.prefix_name}-pg"
  strategy = "cluster"
}

resource "aws_instance" "pilosa" {
  ami           = "ami-6dfe5010"
  instance_type = "${var.pilosa_instance_type}"
  ebs_optimized = true
  placement_group = "${var.prefix_name}-pg"

  connection {
    user = "ubuntu"
  }

  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"

  root_block_device {
    volume_type = "io1"
    volume_size = 200
    iops = 10000
  }

  tags {
    Name = "${var.prefix_name}-pilosa${count.index}"
  }

  count = "${var.pilosa_cluster_size}"

  user_data = <<-EOF
                #!/bin/bash
                echo ${count.index} > /etc/instance-index
                EOF
}

resource "aws_key_pair" "auth" {
  public_key = "${file(var.ssh_public_key)}"
}
