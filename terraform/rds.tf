resource "aws_db_instance" "default" {
  allocated_storage    = 20
  db_name              = var.rds_database
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.rds_username
  password             = var.rds_password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "default" {
  name       = var.rds_subnet_group_name
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = var.rds_subnet_group_name
  }
}

