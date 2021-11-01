output "api_url" {
  value = aws_ecr_repository.api.repository_url
}

output "repository_arns" {
  value = [
    aws_ecr_repository.api.arn,
  ]
}
