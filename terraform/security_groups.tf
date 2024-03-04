# Security Group for SSH Bastion Host
resource "aws_security_group" "ssh_bastion" {
  name        = "ssh-bastion-sg"
  description = "Security group for SSH bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your public IP or IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  # Allow inbound traffic from ALB on port 8080
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow ALB to access instances in private subnet
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define a security group for private instances
resource "aws_security_group" "private_instance" {
  name        = "private-instance-sg"
  description = "Security group for private instances"
  vpc_id      = aws_vpc.main.id  # Assuming you have defined your VPC resource as aws_vpc.main

  # Define ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.ssh_bastion.id]  # Allow SSH traffic from the bastion host security group
  }
  
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  # Define egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Update Security Group for Private Instances to allow SSH from Bastion Host
resource "aws_security_group_rule" "ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks = [aws_vpc.main.cidr_block]
  security_group_id        = aws_security_group.private_instance.id  # Destination is the private instance security group
}


# Create an internet gateway for public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "CloudhightIGW"
  }
}

# Create route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "CloudhightRRT"
  }

}

# Create route table for private subnet 1
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRouteTable1"
  }
}

# Create route table for private subnet 2
resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRouteTable2"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate public subnet 2 with public route table
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id       = aws_subnet.public_subnet_2.id  # Assuming you have two public subnets
  route_table_id  = aws_route_table.public_route_table.id
}
