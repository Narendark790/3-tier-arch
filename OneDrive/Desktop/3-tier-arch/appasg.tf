# Latest Amazon Linux 2 AMI (region-agnostic)
data "aws_ami" "amzn2" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
# Launch Template
resource "aws_launch_template" "app_template" {
  name_prefix               = "swiggy-app-"
  image_id                  = "0c4a668b99e68bbde"
  instance_type             = "t3.micro"
  vpc_security_group_ids    = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum -y update
              yum -y install httpd
              systemctl enable --now httpd
              echo "<h1>Hello from Swiggy App (ASG)</h1>" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "swiggy-app" }
  }
}

# Auto Scaling Group (in PRIVATE subnets, uses NAT for yum)
resource "aws_autoscaling_group" "app_asg" {
  name                      = "swiggy-asg"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = [subnet-03fa54a742101e609, subnet-092bbebd2a91c7046]

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  # Attach target group directly (cleaner than a separate attachment)
  target_group_arns = [aws_lb_target_group.app_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "swiggy-app"
    propagate_at_launch = true
  }
}
