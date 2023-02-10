resource "aws_ec2_transit_gateway" "tgw" {
  description = "all vpc peering"
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-tgw"
  }), local.tags)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_one" {
  subnet_ids         = [aws_subnet.public_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc.id
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-tgw-spot-attachment"
  }), local.tags)
}