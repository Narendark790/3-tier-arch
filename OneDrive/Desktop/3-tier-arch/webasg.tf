###### Create an EC2 Auto Scaling Group - web ######
resource "aws_autoscaling_group" "swiggy-web-asg" {
  name = "swiggy-web-asg"
  launch_template {
    id      = aws_launch_template.swiggy-web-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = ["subnet-06c0691a886046966", "subnet-09e9299a477ac08d3"]
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
}

###### Create a Launch Template for the EC2 instances ######
resource "aws_launch_template" "swiggy-web-template" {
  name_prefix   = "swiggy-web-template"
  image_id      = "ami-0a232144cf20a27a5"
  instance_type = "t3.micro"
  key_name      = "3tierprojectfornarendar"
  network_interfaces {
    associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.app_sg.id]
  }
  user_data = base64encode(file("apache.sh"))
  }
