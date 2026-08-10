resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "platform-nat-eip"
  }

}

resource "aws_nat_gateway" "platform" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_a.id

  tags = {

    Name = "platform-nat"

  }

}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.platform.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.platform.id

  }

  tags = {

    Name = "platform-private-rt"

  }

}

resource "aws_route_table_association" "private_app_a" {

  subnet_id = aws_subnet.private_app_a.id

  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_app_b" {

  subnet_id = aws_subnet.private_app_b.id

  route_table_id = aws_route_table.private.id

}