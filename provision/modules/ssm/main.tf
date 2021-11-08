resource "aws_ssm_parameter" "database_password_parameter" {
  name        = "/${var.service}/db/password"
  type        = "SecureString"
  value       = var.db_password
}

resource "aws_ssm_parameter" "database_username_parameter" {
  name        = "/${var.service}/db/username"
  type        = "SecureString"
  value       = var.db_username
}

resource "aws_ssm_parameter" "database_host_parameter" {
  name        = "/${var.service}/db/host"
  type        = "SecureString"
  value       = var.db_host
}

resource "aws_ssm_parameter" "database_name_parameter" {
  name        = "/${var.service}/db/name"
  type        = "SecureString"
  value       = var.db_name
}
