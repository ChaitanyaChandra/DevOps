# subnet calculator
# https://www.ipaddressguide.com/cidr
# https://www.baeldung.com/cs/get-ip-range-from-subnet-mask

# data block for az
data "aws_availability_zones" "az" {
  state = "available"
}

# creating vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "172.16.0.0/21"
  instance_tenancy = "default"
  # for dns internal routing
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-spot-vpc"
  }), local.tags)
}

# creating internet gateway for vpc
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id
}

# public subnet az-a
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.0.0/22"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.az.names[0]
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-public-subnet"
  }), local.tags)
}


# Creating RT for Public Subnet one
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
  route {
    cidr_block         = "10.0.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-ec2-spot-public-route-table"
  }), local.tags)
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_one]
}

# Route table Association with Public Subnet one
resource "aws_route_table_association" "PublicRT_association_one" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}