data "aws_availability_zones" "az" {
  state = "available"
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true
}



# public subnet az-a
resource "aws_subnet" "public_subnet" {
  count                   = length(var.PUBLIC_SUBNET_CIDR)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.PUBLIC_SUBNET_CIDR[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.az.names[count.index]
}


# private subnet in az-a
resource "aws_subnet" "private_subnet" {
  count             = length(var.PRIVATE_SUBNET_CIDR)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PRIVATE_SUBNET_CIDR[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  depends_on = [aws_subnet.public_subnet]
}