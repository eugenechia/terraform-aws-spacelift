resource "aws_vpc" "spacelift_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "spacelift_public_subnet" {
  vpc_id                  = aws_vpc.spacelift_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "spacelift_internet_gateway" {
  vpc_id = aws_vpc.spacelift_vpc.id

  tags = {
    Name = "spacelift_igw"
  }
}

resource "aws_route_table" "spacelift_public_rt" {
  vpc_id = aws_vpc.spacelift_vpc.id

  tags = {
    Name = "dev_spacelift_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.spacelift_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.spacelift_internet_gateway.id
}

resource "aws_route_table_association" "spacelift_public_assoc" {
  subnet_id      = aws_subnet.spacelift_public_subnet.id
  route_table_id = aws_route_table.spacelift_public_rt.id
}

resource "aws_security_group" "spacelift_sg" {
  name        = "public_sg"
  description = "public security group"
  vpc_id      = aws_vpc.spacelift_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}