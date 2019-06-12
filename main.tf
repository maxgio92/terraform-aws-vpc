# VPC

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-vpc"
  ))}"
}

# Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-igw"
  ))}"
}

# AZs
data "aws_availability_zones" "available" {}

# Subnets

resource "aws_subnet" "public" {
  count = "${var.public_subnet_count}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  cidr_block = "${cidrsubnet(
                        var.vpc_cidr,
                        var.public_subnet_mask_newbits,
                        count.index
                      )}"

  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-pub-net-${count.index}"
  ))}"
}

resource "aws_subnet" "private" {
  count = "${var.private_subnet_count}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  cidr_block = "${cidrsubnet(
                        var.vpc_cidr, 
                        var.private_subnet_mask_newbits, 
                        count.index + var.public_subnet_count
                       )}"

  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-priv-net-${count.index}"
  ))}"
}

# NAT gateways

resource "aws_eip" "nat" {
  count = "${var.public_subnet_count}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-nat-eip-${count.index}"
  ))}"
}

resource "aws_nat_gateway" "gw" {
  count = "${var.public_subnet_count}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-ngw-${count.index}"
  ))}"
}

# Routing tables

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-pub-rtb"
  ))}"
}

resource "aws_route_table_association" "public" {
  count = "${var.public_subnet_count}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  count = "${var.private_subnet_count}"

  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = "${element(aws_nat_gateway.gw.*.id, count.index)}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.prefix_name}-priv-rtb-${count.index}"
  ))}"
}

resource "aws_route_table_association" "private" {
  count = "${var.private_subnet_count}"

  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"

  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
