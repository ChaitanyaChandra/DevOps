output "key_name" {
  value = aws_key_pair.deployer.key_name
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}


output "aws_sg_id" {
  value = aws_security_group.internet_facing.id
}

output "aws_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "zone_id" {
  value = aws_route53_zone.dns.zone_id
}