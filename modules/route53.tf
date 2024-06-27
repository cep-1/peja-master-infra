resource "aws_route53_zone" "main_zone" {
    name = "awskosova.com"
}

resource "aws_route53_record" "peja-a" {
    zone_id = aws_route53_zone.main_zone.zone_id
    name    = "peja.awskosova.com"
    type    = "A"
    
    alias {
        name = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
        evaluate_target_health = true
    }
}