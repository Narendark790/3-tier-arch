# Create a Load Balancer
resource "aws_lb" "external" {
  name               = "swiggy-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.swiggy-alb-sg-1.id]
  subnets            = [
    aws_subnet.swiggy-pub-sub-1.id,
    aws_subnet.swiggy-pub-sub-2.id
  ]

  enable_deletion_protection = false
}

# Create a Target Group
resource "aws_lb_target_group" "external_elb" {
  name     = "external-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.swiggy-vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# Attach Auto Scaling Group Instances to Target Group
resource "aws_autoscaling_attachment" "swiggy_web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.swiggy_web_asg.name
  alb_target_group_arn   = aws_lb_target_group.external.arn
}
