# Security Group for ASG
resource "aws_security_group" "swiggy-ec2-asg-sg" {
  name        = "swiggy-ec2-asg-sg"
  description = "Security group for EC2 instances in ASG"
  vpc_id      = aws_vpc.swiggy-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "swiggy-ec2-asg-sg"
  }
}


# Security Group for Database
resource "aws_security_group" "swiggy-db-sg" {
  name        = "swiggy-db-sg"
  description = "Security group for Swiggy Database"
  vpc_id      = aws_vpc.swiggy-vpc.id

  ingress {
    from_port = 3306 # MySQL/Aurora port
    to_port   = 3306
    protocol  = "tcp"
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "Swiggy DB SG"
  }
}

# Security Group for Application Load Balancer
resource "aws_security_group" "swiggy-alb-sg-1" {
  name        = "swiggy-alb-sg-1"
  description = "Security group for Swiggy Application Load Balancer"
  vpc_id      = aws_vpc.swiggy-vpc.id

  ingress {
    from_port   = 80 # HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443 # HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "Swiggy ALB SG"
  }
}

# Create a Security Group for ASG
resource "aws_security_group" "swiggy-ec2-asg-sg-app" {
  name        = "swiggy-ec2-asg-sg-app"
  description = "Security group for Swiggy EC2 instances in ASG"
  vpc_id      = aws_vpc.swiggy-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "swiggy-ec2-asg-sg-app"
  }
}
