resource "aws_elb" "tfonaws" {
  name = "terraform-on-aws-elb"

  #availability_zones = ["us-west-2a", "us-west-2b"]
  subnets = ["${aws_subnet.tfonaws.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "tcp"
    instance_port     = "${var.server_port}"
    instance_protocol = "tcp"
  }

  security_groups = ["${aws_security_group.elb.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }

  tags {
    key   = "Name"
    value = "terraform-on-aws-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "elb_public_dns" {
  value = "${aws_elb.tfonaws.dns_name}"
}
