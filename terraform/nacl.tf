
# Create network ACL for private subnets
resource "aws_network_acl" "private_subnet_acl" {
  vpc_id = aws_vpc.main.id  # Assuming you have defined your VPC resource as aws_vpc.main

  tags = {
    Name = "PrivateSubnetACL"
  }
}

# Example Network ACL rule allowing inbound traffic on port 8080 from the public subnet
resource "aws_network_acl_rule" "allow_inbound_8080" {
  network_acl_id = aws_network_acl.private_subnet_acl.id
  rule_number    = 100
  protocol       = "6"   # TCP protocol
  rule_action    = "allow"
  cidr_block     = var.public_subnet_cidr_block  # CIDR block of the public subnet
  from_port      = 8080
  to_port        = 8080
}

# Example Network ACL rule allowing inbound traffic on port 8080 from the second public subnet
resource "aws_network_acl_rule" "allow_inbound_8080_2" {
  network_acl_id = aws_network_acl.private_subnet_acl.id
  rule_number    = 101  # Ensure a unique rule number
  protocol       = "6"   # TCP protocol
  rule_action    = "allow"
  cidr_block     = var.public_subnet_cidr_block_2 # CIDR block of the public subnet
  from_port      = 8080
  to_port        = 8080
}

# Example Network ACL rule allowing outbound traffic on port 8080 to the public subnet
resource "aws_network_acl_rule" "allow_outbound_8080" {
  network_acl_id = aws_network_acl.private_subnet_acl.id
  rule_number    = 102  # Ensure a unique rule number
  protocol       = "6"   # TCP protocol
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr_block # Assuming your VPC CIDR block
  from_port      = 8080
  to_port        = 8080
}



# Example Network ACL rule allowing inbound traffic on port 8080 from the ALB
resource "aws_network_acl_rule" "allow_inbound_8080_alb" {
  network_acl_id = aws_network_acl.private_subnet_acl.id
  rule_number    = 103  # Ensure a unique rule number
  protocol       = "6"   # TCP protocol
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"  # Specify the CIDR block of the ALB
  from_port      = 8080
  to_port        = 8080
}