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

# Launch Template
resource "aws_launch_template" "app_template" {
  name_prefix   = "swiggy-app-"
  image_id      = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Swiggy App" > /var/www/html/index.html
              EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                = "swiggy-asg"
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.pvt1.id, aws_subnet.pvt2.id]

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "swiggy-app"
    propagate_at_launch = true
  }
}

# Output ALB DNS
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
