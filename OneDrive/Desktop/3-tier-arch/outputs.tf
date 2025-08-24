output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "Public DNS of the Application Load Balancer"
}
