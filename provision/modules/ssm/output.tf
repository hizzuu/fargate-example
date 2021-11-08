output "ssm_parameter_database_username_arn" {
  value = aws_ssm_parameter.database_username_parameter.arn
}

output "ssm_parameter_database_password_arn" {
  value = aws_ssm_parameter.database_password_parameter.arn
}

output "ssm_parameter_database_host_arn" {
  value = aws_ssm_parameter.database_host_parameter.arn
}

output "ssm_parameter_environments" {
  value = [
    {
      name  = "DB_USER"
      valueFrom = aws_ssm_parameter.database_username_parameter.arn
    },
    {
      name  = "DB_PASS"
      valueFrom = aws_ssm_parameter.database_password_parameter.arn
    },
    {
      name  = "DB_HOST"
      valueFrom = aws_ssm_parameter.database_host_parameter.arn
    },
    {
      name = "DB_NAME"
      valueFrom = aws_ssm_parameter.database_name_parameter.arn
    }
  ]
}
