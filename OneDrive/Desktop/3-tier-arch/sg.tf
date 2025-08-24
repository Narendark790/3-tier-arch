# Availability Zones
data "aws_availability_zones" "azs" {
  state = "available"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "swiggy-vpc" }
}

# Internet Gateway (for public subnets)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "swiggy-igw" }
}

# Public subnets (for ALB)
resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "swiggy-pub-1" }
}

resource "aws_subnet" "pub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true
  tags = { Name = "swiggy-pub-2" }
}

# Private subnets (for ASG instances)
resource "aws_subnet" "pvt1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]
  tags = { Name = "swiggy-pvt-1" }
}

resource "aws_subnet" "pvt2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = data.aws_availability_zones.azs.names[1]
  tags = { Name = "swiggy-pvt-2" }
}

# NAT for private subnets (lets instances reach yum repos)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "swiggy-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub1.id
  tags          = { Name = "swiggy-nat" }
  depends_on    = [aws_internet_gateway.igw]
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "swiggy-public-rt" }
}

resource "aws_route_table_association" "pub1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.pub1.id
}
resource "aws_route_table_association" "pub2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.pub2.id
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "swiggy-private-rt" }
}

resource "aws_route_table_association" "pvt1" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.pvt1.id
}
resource "aws_route_table_association" "pvt2" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.pvt2.id
}

# Security group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "swiggy-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "vpc-0ab9b74d8c4bc3af0" # <-- change to your VPC id

  ingress {
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
    Name = "swiggy-alb-sg"
  }
}

# Security group for EC2/ASG
resource "aws_security_group" "app_sg" {
  name        = "swiggy-app-sg"
  description = "Allow traffic from ALB"
  vpc_id      = "vpc-0ab9b74d8c4bc3af0"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
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

# App SG (allow 80 from ALB SG)
resource "aws_security_group" "app_sg" {
  name   = "swiggy-app-sg"
  vpc_id = "vpc-0ab9b74d8c4bc3af0"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB SG (allow 3306 from App SG) — optional if you’re using RDS
resource "aws_security_group" "db_sg" {
  name   = "swiggy-db-sg"
  vpc_id = "vpc-0ab9b74d8c4bc3af0"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


 ingress {
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

  tags = { Name = "swiggy-alb-sg" }
}

# - App SG: allow 80 only from ALB SG
resource "aws_security_group" "app_sg" {
  name        = "swiggy-app-sg"
  description = "App SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  # (Optional) SSH for troubleshooting - restrict as needed
  # ingress { from_port = 22 to_port = 22 protocol = "tcp" cidr_blocks = ["YOUR.IP.ADDR.0/24"] }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = { Name = "swiggy-app-sg" }
}
