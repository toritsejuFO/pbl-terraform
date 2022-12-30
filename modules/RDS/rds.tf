# Ccreate the subnet group for the RDS instance using the private subnet
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "iac-rds"
  subnet_ids = var.private_subnets

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-RDS"
    },
  )
}

# Create the RDS instance with the subnets group
resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "iacdb"
  username               = var.master_username
  password               = var.master_password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.private_subnets
  multi_az               = "true"
  identifier             = "iac-rds-instance"
}
