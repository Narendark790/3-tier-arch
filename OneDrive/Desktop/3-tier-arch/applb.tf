# ALB
resource "aws_lb" "app_lb" {
  name               = "swiggy-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-03fa54a742101e609", "subnet-092bbebd2a91c7046"]
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "swiggy-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0ab9b74d8c4bc3af0"

  health_check {
    path    = "/"
    matcher = "200-399"
  }
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

# Output
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
