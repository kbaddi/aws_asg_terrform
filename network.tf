resource "aws_vpc" "tfonaws" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags {
    name = "tfonaws"
  }
}

resource "aws_internet_gateway" "tfonaws" {
  vpc_id = "${aws_vpc.tfonaws.id}"

  tags = {
    name = "tfonaws"
  }
}

resource "aws_subnet" "tfonaws" {
  vpc_id     = "${aws_vpc.tfonaws.id}"
  cidr_block = "${var.subnet_cidr}"

  tags {
    name = "Subnet1"
  }
}

resource "aws_route_table" "tfonaws_public" {
  vpc_id = "${aws_vpc.tfonaws.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tfonaws.id}"
  }

  tags {
    Name = "Public_Subnet"
  }
}

resource "aws_route_table_association" "tfonaws_public" {
  subnet_id      = "${aws_subnet.tfonaws.id}"
  route_table_id = "${aws_route_table.tfonaws_public.id}"
}
