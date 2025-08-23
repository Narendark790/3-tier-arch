# Application Load Balancer
resource "aws_lb" "external" {
  name               = "swiggy-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  security_groups    = [aws_security_group.lb_sg.id]
}

# Target Group
resource "aws_lb_target_group" "external" {
  name     = "external-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
