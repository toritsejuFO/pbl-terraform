# Ccreate the subnet group for the RDS instance using the private subnet
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "iac-rds"
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]

  tags = merge(
    local.tags,
    {
      Name = "${var.Name}-rds"
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
  vpc_security_group_ids = [aws_security_group.datalayer_sg.id]
  multi_az               = "true"
  identifier             = "iac-rds-instance"
}
