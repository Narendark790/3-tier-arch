# Application Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name = "swigg-app-asg"

  launch_template {
    id      = aws_launch_template.app-temp.id
    version = "$Latest"
  }

  max_size            = 4
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [
    aws_subnet.priv-subnet-1.id,
    aws_subnet.priv-subnet-2.id
  ]

  tag {
    key                 = "Name"
    value               = "swigg-app-asg"
    propagate_at_launch = true
  }
}

# Launch Template
resource "aws_launch_template" "app-temp" {
  name_prefix   = "app-launch-template-"
  image_id      = "ami-0861f4e788f5069dd"
  instance_type = "t3.micro"

  key_name = "nare"
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2-app.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install mysql -y
    systemctl enable mysql
    systemctl start mysql
  EOF
  )

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [user_data]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-launch-template-instance"
    }
  }
}
