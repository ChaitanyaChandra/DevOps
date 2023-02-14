data "cloudflare_zone" "zone" {
  name = "chaitu.net"
}

resource "cloudflare_record" "record" {
  count   = var.internal ? 0 : 1
  zone_id = data.cloudflare_zone.zone.id
  name    = "app"
  value   = aws_lb.main.dns_name
  type    = "A"
  ttl     = 1
  proxied = true
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = "aiRxpo3xooOe_5LAM4bfq9hy_SnvFvyA4IO4XNKZ"
}

resource "aws_route53_record" "route" {
  zone_id = data.terraform_remote_state.bastian_host_and_apps.outputs.zone_id
  name    = var.internal ? "backend" : "app"
  type    = "A"
  ttl     = 60
  records = [aws_lb.main.dns_name]
}