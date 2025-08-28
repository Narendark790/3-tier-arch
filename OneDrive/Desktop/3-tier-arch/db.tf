# Database Subnet Group
resource "aws_db_subnet_group" "db" {
  name       = "swigg-db-subnet-group"
  subnet_ids = [
    aws_subnet.priv-subnet-3.id,
    aws_subnet.priv-subnet-4.id
  ]
}

# MySQL RDS Instance
resource "aws_db_instance" "db-instance" {
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0" # always good to be explicit
  identifier             = "swiggy-db-${random_string.suffix.result}" # unique name
  username               = "admin"
  password               = "790dhoni"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.ec2-db.id]
  multi_az               = false                 # safer for micro instances
  skip_final_snapshot    = true
  publicly_accessible    = false

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [password] # only ignore password changes
  }
}

# Random string to make DB identifier unique
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
