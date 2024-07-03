output "load_balancer_dns_name" {
  value = aws_lb.app_nlb.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.app_nlb.zone_id
}