provider "aws" {
shared_credentials_file  = "~/.aws/credentials"
  region     = "us-east-1"
}

resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = "${file("init.sh")}"
  key_name               = var.key
  vpc_security_group_ids = ["${aws_security_group.allow.id}"]
}


resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
data "aws_availability_zones" "avail" { 
  all_availability_zones = true

}
resource "aws_security_group" "allow" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    description      = "TLS from VPC"
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_elb" "loadbalancer" {
  name                   = "demo"
  availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
listener {
  instance_port          = 80
  instance_protocol      = "http"
  lb_port                = 80
  lb_protocol            = "http"
}


health_check {
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout             = 3
  target              = "HTTP:80/"
  interval            = 30
}

instances                   = ["${aws_instance.instance.id}"]
cross_zone_load_balancing   = true
idle_timeout                = 400
connection_draining         = true
connection_draining_timeout = 400

tags = {
  Name = "foobar-terraform-elb"
}
}






