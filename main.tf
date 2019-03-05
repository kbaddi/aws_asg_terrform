provider "aws" {
  profile = "kiranbaddi"
  region  = "us-west-2"
}

data "template_file" "setup" {
  template = "${file("${path.module}/Templates/setup.tpl")}"
}

data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] #Canonical
}

resource "aws_launch_configuration" "tfonaws" {
  image_id        = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.tfonaws.id}"]
  key_name        = "${var.key_name}"
  user_data       = "${data.template_file.setup.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

# Get the all AZs

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "tfonaws" {
  launch_configuration = "${aws_launch_configuration.tfonaws.id}"
  load_balancers       = ["${aws_elb.tfonaws.name}"]
  health_check_type    = "ELB"
  vpc_zone_identifier  = ["${aws_subnet.tfonaws.id}"]
  min_size             = "1"
  max_size             = "3"

  availability_zones = ["${data.aws_availability_zones.all.names}"]

  tags {
    key                 = "name"
    value               = "terraform-on-aws-asg"
    propagate_at_launch = true
  }
}
