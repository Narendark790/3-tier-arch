# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "swiggy-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.pub1.id, aws_subnet.pub2.id]
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "swiggy-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Output ALB DNS
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
