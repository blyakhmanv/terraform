variable "server_port" {
description = "The port the server will use for HTTP requests"
  default = "8080"
}


provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "vbtest" {
ami = "ami-40d28157"
instance_type = "t2.micro"
user_data = <<-EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p "${var.server_port}" &EOF

  vpc_security_group_ids = ["${aws_security_group.vbgroup.id}"]
  tags {
  Name = "VBtest"
}
}

resource "aws_security_group" "vbgroup" {
name = "terraform-example-instance"
ingress {
from_port = "${var.server_port}"
to_port = "${var.server_port}"
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}

output "public_ip" {
value = "${aws_instance.vbtest.public_ip}"
}