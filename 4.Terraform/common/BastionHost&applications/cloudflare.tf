data "cloudflare_zone" "zone" {
  name = "chaitu.net"
}

resource "cloudflare_record" "record" {
  count   = length(local.instance_types)
  zone_id = data.cloudflare_zone.zone.id
  name    = local.instance_types[count.index]
  value   = aws_spot_instance_request.vm.*.public_ip[count.index]
  type    = "A"
  ttl     = 1
  proxied = true
}

provider "cloudflare" {
  api_token = "aiRxpo3xooOe_5LAM4bfq9hy_SnvFvyA4IO4XNKZ"
}