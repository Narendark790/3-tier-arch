# Application Load Balancer

# Application Load Balancer Configuration
resource "aws_lb" "app-lb" {
  name               = "swigg-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2-lb.id]
  subnets            = [aws_subnet.pub-subnet-1.id, aws_subnet.pub-subnet-2.id]

  tags = {
    "Name" = "swigg-app-lb"
  }

}

# Application Load Balancer Target Group
resource "aws_lb_target_group" "app-tg" {
  name     = "swigg-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "swigg-app-tg"
  }
}


resource "aws_autoscaling_attachment" "app-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.web.name
  lb_target_group_arn    = aws_lb_target_group.app-tg.arn
}
