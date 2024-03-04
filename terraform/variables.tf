# variables.tf

variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "us-west-2" # Change to your desired region
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "192.168.0.0/16" # Change to your desired CIDR block for the VPC
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet 1."
  type        = string
  default     = "192.168.1.0/24" # Change to your desired CIDR block for public subnet 1
}

variable "public_subnet_cidr_block_2" {
  description = "CIDR block for public subnet 2."
  type        = string
  default     = "192.168.2.0/24" # Change to your desired CIDR block for public subnet 2
}

variable "private_subnet_cidr_block_1" {
  description = "CIDR block for private subnet 1."
  type        = string
  default     = "192.168.3.0/24" # Change to your desired CIDR block for private subnet 1
}

variable "private_subnet_cidr_block_2" {
  description = "CIDR block for private subnet 2."
  type        = string
  default     = "192.168.4.0/24" # Change to your desired CIDR block for private subnet 2
}

variable "availability_zone1" {
  description = "Availability Zone for subnet 1."
  type        = string
  default     = "us-west-2a" # Change to your desired Availability Zone for subnet 1
}

variable "availability_zone2" {
  description = "Availability Zone for subnet 2."
  type        = string
  default     = "us-west-2b" # Change to your desired Availability Zone for subnet 2
}
