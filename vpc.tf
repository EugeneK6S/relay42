# Define a vpc
resource "aws_vpc" "relayVPC" {
  cidr_block = "192.0.0.0/16"

  tags {
    Name = "relayVPC"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "relayInetGW" {
  vpc_id = "${aws_vpc.relayVPC.id}"

  tags {
    Name = "relayInetGW"
  }
}

# Public subnet
resource "aws_subnet" "relayPublicSN1" {
  vpc_id            = "${aws_vpc.relayVPC.id}"
  cidr_block        = "192.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags {
    Name = "relayPublicSN1"
  }
}

resource "aws_subnet" "relayPublicSN2" {
  vpc_id            = "${aws_vpc.relayVPC.id}"
  cidr_block        = "192.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags {
    Name = "relayPublicSN2"
  }
}

resource "aws_subnet" "relayPublicSN3" {
  vpc_id            = "${aws_vpc.relayVPC.id}"
  cidr_block        = "192.0.3.0/24"
  availability_zone = "eu-central-1c"

  tags {
    Name = "relayPublicSN3"
  }
}

# Routing table for public subnet
resource "aws_route_table" "relayRouteTable0" {
  vpc_id = "${aws_vpc.relayVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.relayInetGW.id}"
  }

  tags {
    Name = "relayRouteTable0"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "relayRTA1" {
  subnet_id      = "${aws_subnet.relayPublicSN1.id}"
  route_table_id = "${aws_route_table.relayRouteTable0.id}"
}

resource "aws_route_table_association" "relayRTA2" {
  subnet_id      = "${aws_subnet.relayPublicSN2.id}"
  route_table_id = "${aws_route_table.relayRouteTable0.id}"
}

resource "aws_route_table_association" "relayRTA3" {
  subnet_id      = "${aws_subnet.relayPublicSN3.id}"
  route_table_id = "${aws_route_table.relayRouteTable0.id}"
}

# ECS Instance Security group

resource "aws_security_group" "relaySG" {
  name        = "relaySG"
  description = "Security group"
  vpc_id      = "${aws_vpc.relayVPC.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  # ingress {
  #   from_port = 0
  #   to_port   = 0
  #   protocol  = "tcp"


  #   cidr_blocks = [
  #     "${var.test_public_01_cidr}",
  #     "${var.test_public_02_cidr}",
  #   ]
  # }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags {
    Name = "relaySG"
  }
}
