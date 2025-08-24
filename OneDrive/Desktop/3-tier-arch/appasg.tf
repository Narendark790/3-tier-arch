# Create an EC2 Auto Scaling Group - app
resource "aws_autoscaling_group" "swiggy_app_asg" {
  name = "swiggy-app-asg"

  launch_template {
    id      = aws_launch_template.swiggy_app_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [
    aws_subnet.swiggy_pvt_sub_1.id,
    aws_subnet.swiggy_pvt_sub_2.id
  ]

  min_size         = 2
  max_size         = 3
  desired_capacity = 2
}


# Create a launch template for the EC2 instances
resource "aws_launch_template" "swiggy-app-template" {
  name_prefix   = "swiggy-app-template"
  image_id      = "ami-0a232144cf20a27a5"
  instance_type = "t3.micro"
  key_name      = "3tierprojectnarendar"

  network_interfaces {
    security_groups             = [aws_security_group.swiggy-ec2-asg-sg-app.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash

    sudo yum install mysql -y
  EOF
  )

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

