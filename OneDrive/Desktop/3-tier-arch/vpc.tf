# VPC
resource "aws_vpc" "swiggy-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "swiggy-vpc"
  }
}

