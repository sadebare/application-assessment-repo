# Create public subnet and associate with Route Table
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.availability_zone1

  # Specify the attribute directly
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

# Create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_block_2
  availability_zone = var.availability_zone2

  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}



# Create private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_block_1
  availability_zone = var.availability_zone1

  tags = {
    Name = "private_subnet_1"
  }
}

# Create private subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_block_2
  availability_zone = var.availability_zone2

  tags = {
    Name = "private_subnet_2"
  }
}


# Create Elastic IP address for NAT Gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NAT Gateway"
  }
}

# Update route table for private subnet to route internet-bound traffic through NAT Gateway
resource "aws_route" "private_subnet_route_1" {
  route_table_id            = aws_route_table.private_route_table_1.id
  destination_cidr_block   = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.nat_gateway.id
}

# Associate private subnet 1 with the updated route table
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

# Update route table for private subnet 2 to route internet-bound traffic through NAT Gateway
resource "aws_route" "private_subnet_route_2" {
  route_table_id      = aws_route_table.private_route_table_2.id
  destination_cidr_block   = "0.0.0.0/0"
  nat_gateway_id      = aws_nat_gateway.nat_gateway.id
}

# Associate private subnet 2 with the updated route table
resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}
