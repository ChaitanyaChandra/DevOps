# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create the VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create the public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public"
  }
}

# Create the private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private"
  }
}

# Create the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
}

# Create the NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

# Create the elastic IP address for the NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}

# Create the route tables
resource "aws_route_table" "public" {
  count                   = length(var.PUBLIC_SUBNET_CIDR)
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.PUBLIC_SUBNET_CIDR[count.index]
  map_public_ip_on_launch = true
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}


resource "aws_route_table" "private" {
  count                   = length(var.PRIVATE_SUBNET_CIDR)
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.PRIVATE_SUBNET_CIDR[count.index]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

## Associate the subnets with the route tables
#resource "aws_route_table_association" "public" {
#  subnet_id      = aws_subnet.public.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "private" {
#  subnet_id      = aws_subnet.private.id
#  route_table_id = aws_route_table.private.id
#}
