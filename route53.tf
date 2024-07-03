resource "aws_route53_zone" "main_r53_zone" {
    provider = aws.eu_central_1
    name = "peja.awskosova.com"
}

resource "aws_route53_record" "nlb_a_record_eu" {
  provider = aws.eu_central_1
  zone_id  = aws_route53_zone.main_r53_zone.zone_id
  name     = "*.peja.awskosova.com"
  type     = "A"

  alias {
    name                   = module.master-infra-eu.load_balancer_dns_name
    zone_id                = module.master-infra-eu.load_balancer_zone_id
    evaluate_target_health = false
  }

  set_identifier = "eu-central-1-nlb"
  latency_routing_policy {
    region = "eu-central-1"
  }
}

resource "aws_route53_record" "nlb_a_record_us" {
  provider = aws.us_east_1
  zone_id  = aws_route53_zone.main_r53_zone.zone_id
  name     = "*.peja.awskosova.com"
  type     = "A"

  alias {
    name                   = module.master-infra-us.load_balancer_dns_name
    zone_id                = module.master-infra-us.load_balancer_zone_id
    evaluate_target_health = false
  }

  set_identifier = "us-east-1-nlb"
  latency_routing_policy {
    region = "us-east-1"
  }
}

resource "cloudflare_record" "ns_1" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = "56825932f5dcbbe3a65ffedb9a49b7b2"
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[0]
}
resource "cloudflare_record" "ns_2" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = "56825932f5dcbbe3a65ffedb9a49b7b2"
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[1]
}
resource "cloudflare_record" "ns_3" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = "56825932f5dcbbe3a65ffedb9a49b7b2"
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[2]
}
resource "cloudflare_record" "ns_4" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = "56825932f5dcbbe3a65ffedb9a49b7b2"
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[3]
}

