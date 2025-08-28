# Web Application Auto Scaling Group

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name = "swigg-web-asg"
  launch_template {
    id      = aws_launch_template.temp.id
    version = "$Latest"
  }

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.pub-subnet-1.id, aws_subnet.pub-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

# Launch Template
resource "aws_launch_template" "temp" {
  name_prefix   = "web-launch-template-"
  image_id      = "ami-0861f4e788f5069dd"
  instance_type = "t3.micro"
  key_name      = "mumkey"
network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2-web.id]
  }

  user_data = base64encode(file("apache.sh"))
  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-launch-template-instance"
    }
  }

}
