resource "aws_route53_zone" "dns" {
  name = var.domain
  vpc {
    vpc_id = aws_vpc.vpc.id
  }
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-r53"
  }), local.tags)
}

resource "aws_route53_record" "route" {
  count   = length(local.instance_types)
  zone_id = aws_route53_zone.dns.zone_id
  name    = "${local.instance_types[count.index]}.${var.domain}"
  type    = "A"
  ttl     = 60
  records = "${aws_spot_instance_request.vm.${count.index}.public_ip}"
}