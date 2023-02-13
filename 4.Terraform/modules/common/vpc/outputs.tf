output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet
}

output "public_subnets" {
  value = aws_subnet.public_subnet
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}