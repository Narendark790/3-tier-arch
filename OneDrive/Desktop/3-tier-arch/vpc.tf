###    3 TIER ARCHITECTURE VPC    ###


# creating VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "3tier_vpc "
  }
}

# creating Internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "3tier_igw"
  }

}

# creating NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub-subnet-1.id
  tags = {
    "Name" = "3tier_nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

# creating Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    "Name" = "3tier_eip"
  }
}

# creating public subnet
resource "aws_subnet" "pub-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "3tier_pub_subnet_1"
  }
}

resource "aws_subnet" "pub-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "3tier_pub_subnet_2"
  }
}

# creating private subnet
resource "aws_subnet" "priv-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    "Name" = "3tier_priv_subnet_1"
  }
}

resource "aws_subnet" "priv-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    "Name" = "3tier_priv_subnet_2"
  }
}

resource "aws_subnet" "priv-subnet-3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    "Name" = "3tier_priv_subnet_3"
  }
}

resource "aws_subnet" "priv-subnet-4" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    "Name" = "3tier_priv_subnet_4"
  }
}

# creating route table for public subnet
resource "aws_route_table" "pub-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "3tier_pub_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# creating route table for private subnet
resource "aws_route_table" "priv-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "3tier_priv_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

# associating route table with subnet
resource "aws_route_table_association" "rt-assoc-1" {
  route_table_id = aws_route_table.pub-route-table.id
  subnet_id      = aws_subnet.pub-subnet-1.id
}

resource "aws_route_table_association" "rt-assoc-2" {
  route_table_id = aws_route_table.pub-route-table.id
  subnet_id      = aws_subnet.pub-subnet-2.id
}

resource "aws_route_table_association" "rt-assoc-3" {
  route_table_id = aws_route_table.priv-route-table.id
  subnet_id      = aws_subnet.priv-subnet-1.id
}

resource "aws_route_table_association" "rt-assoc-4" {
  route_table_id = aws_route_table.priv-route-table.id
  subnet_id      = aws_subnet.priv-subnet-2.id
}

resource "aws_route_table_association" "rt-assoc-5" {
  route_table_id = aws_route_table.priv-route-table.id
  subnet_id      = aws_subnet.priv-subnet-3.id
}

resource "aws_route_table_association" "rt-assoc-6" {
  route_table_id = aws_route_table.priv-route-table.id
  subnet_id      = aws_subnet.priv-subnet-4.id
}

