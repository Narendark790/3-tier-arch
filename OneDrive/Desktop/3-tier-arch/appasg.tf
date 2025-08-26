# Security Group for App Servers
resource "aws_security_group" "app_sg" {
  name        = "swiggy-app-sg"
  description = "Allow App traffic"
  vpc_id      = aws_vpc.main.id   # replace with your actual VPC ID or variable

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swiggy-app-sg"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "swiggy-alb-sg"
  description = "Allow inbound HTTP/HTTPS for ALB"
  vpc_id      = aws_vpc.main.id   # replace with your actual VPC ID or variable

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swiggy-alb-sg"
  }
}
