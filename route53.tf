resource "aws_route53_zone" "main_r53_zone" {
    provider = aws.eu_central_1
    name = "peja.awskosova.com"
}

resource "aws_route53_record" "nlb_a_record" {
  provider = aws.eu_central_1
  zone_id = aws_route53_zone.main_r53_zone.zone_id
  name    = "*.peja.awskosova.com"
  type    = "A"

  alias {
    name                   = module.master-infra-eu.load_balancer_dns_name
    zone_id                = module.master-infra-eu.load_balancer_zone_id
    evaluate_target_health = false
  }
}

resource "cloudflare_record" "ns_1" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = aws_route53_zone.main_r53_zone.zone_id
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[0]
}
resource "cloudflare_record" "ns_2" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = aws_route53_zone.main_r53_zone.zone_id
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[1]
}
resource "cloudflare_record" "ns_3" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = aws_route53_zone.main_r53_zone.zone_id
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[2]
}
resource "cloudflare_record" "ns_4" {
  depends_on = [aws_route53_zone.main_r53_zone]

  zone_id = aws_route53_zone.main_r53_zone.zone_id
  name    = "peja"
  type    = "NS"
  ttl     = 3600
  value   = aws_route53_zone.main_r53_zone.name_servers[4]
}

