# Launch Template for EC2 instances
resource "aws_launch_template" "app_template" {
  name_prefix   = "swiggy-app-"
  image_id      = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (update if needed)
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

# Auto Scaling Group (App Tier)
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
