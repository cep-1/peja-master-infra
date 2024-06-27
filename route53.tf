# resource "aws_route53_zone" "main_zone" {
#     name = "peja.awskosova.com"
# }

# resource "aws_route53_record" "latency_us" {
#   zone_id = aws_route53_zone.main_zone.zone_id
#   name    = "vote.peja.awskosova.com"
#   type    = "CNAME"
#   ttl     = 300
#   set_identifier = "us"
#   latency_routing_policy {
#     region = "us-east-1"
#   }
#   records = [module.master-infra-us.lb_dns_name]
# }

# resource "aws_route53_record" "latency_eu" {
#   zone_id = aws_route53_zone.main_zone.zone_id
#   name    = "vote.peja.awskosova.com"
#   type    = "CNAME"
#   ttl     = 300
#   set_identifier = "eu"
#   latency_routing_policy {
#     region = "eu-central-1"
#   }
#   records = [module.master-infra-eu.lb_dns_name]
# }