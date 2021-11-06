resource "aws_db_subnet_group" "default" {
  name       = "${var.service}"
  subnet_ids = var.subnet_ids
  tags = {
    Service     = var.service
  }
}

resource "aws_db_instance" "db" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0.23"
  instance_class    = var.instance_class
  identifier        = var.service
  name              = var.database_name
  username          = var.master_username
  password          = var.master_password
  skip_final_snapshot = true
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.default.id
}