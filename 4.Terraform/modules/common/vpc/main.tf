# subnet calculator
# https://www.ipaddressguide.com/cidr
# data block for az
data "aws_availability_zones" "az" {
  state = "available"
}

# creating vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-vpc"
  }), local.tags)
}

## creating internet gateway for vpc
#resource "aws_internet_gateway" "IGW" {
#  vpc_id = aws_vpc.vpc.id
#  tags = merge(tomap({
#    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-igw"
#  }), local.tags)
#}

# public subnet az-a
resource "aws_subnet" "public_subnet" {
  count                   = length(var.PUBLIC_SUBNET_CIDR)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.PUBLIC_SUBNET_CIDR[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-public-subnet-${count.index}"
  }), local.tags)
}

#
# # Creating RT for Public Subnet one
#resource "aws_route_table" "public_route_table" {
#  vpc_id = aws_vpc.vpc.id
#  route {
#    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
#    gateway_id = aws_internet_gateway.IGW.id
#  }
#  route {
#    cidr_block         = "172.16.0.0/21"
#    transit_gateway_id = data.terraform_remote_state.remote.outputs.tgw_id
#  }
#  tags = merge(tomap({
#    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-public-route-table"
#  }), local.tags)
#  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_one]
#}
#
## Route table Association with Public Subnet one
#resource "aws_route_table_association" "PublicRT_association" {
#  count          = length(var.PUBLIC_SUBNET_CIDR)
#  subnet_id      = aws_subnet.public_subnet[count.index].id
#  route_table_id = aws_route_table.public_route_table.id
#}

# private subnet in az-a
resource "aws_subnet" "private_subnet" {
  count             = length(var.PRIVATE_SUBNET_CIDR)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PRIVATE_SUBNET_CIDR[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-private-subnet-${count.index}"
  }), local.tags)
  depends_on = [aws_subnet.public_subnet]
}

## Creating RT for Private Subnet one
#resource "aws_route_table" "private_route_table_one" {
#  vpc_id = aws_vpc.vpc.id
#  route {
#    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
#    nat_gateway_id = aws_nat_gateway.NATgw_one.id
#  }
#  route {
#    cidr_block         = "172.16.0.0/21"
#    transit_gateway_id = data.terraform_remote_state.remote.outputs.tgw_id
#  }
#  tags = merge(tomap({
#    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-private-route-table"
#  }), local.tags)
#  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_one, aws_subnet.private_subnet]
#}
#
## Route table Association with Private Subnets one
#resource "aws_route_table_association" "PrivateRT_association" {
#  count          = length(var.PRIVATE_SUBNET_CIDR)
#  subnet_id      = aws_subnet.private_subnet[count.index].id
#  route_table_id = aws_route_table.private_route_table_one.id
#}
#
#
#resource "aws_eip" "natIP_one" {
#  vpc = true
#  tags = merge(tomap({
#    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-nat-eip"
#  }), local.tags)
#
#}
#
#
## Creating the NAT Gateway using subnet_id and allocation_id in publicIP for internet access in private subnet
#resource "aws_nat_gateway" "NATgw_one" {
#  allocation_id = aws_eip.natIP_one.id
#  subnet_id     = aws_subnet.public_subnet[0].id
#  tags = merge(tomap({
#    "Name" = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-nat-gateway"
#  }), local.tags)
#  depends_on = [
#    "aws_internet_gateway.IGW",
#    "aws_eip.natIP_one"
#  ]
#}
#
#
#resource "aws_route53_vpc_association_authorization" "auth" {
#  vpc_id  = aws_vpc.vpc.id
#  zone_id = data.terraform_remote_state.remote.outputs.zone_id
#}
#
#resource "aws_route53_zone_association" "r53" {
#  vpc_id  = aws_route53_vpc_association_authorization.auth.vpc_id
#  zone_id = aws_route53_vpc_association_authorization.auth.zone_id
#}