resource "aws_ecr_repository" "api" {
  name                 = "${var.service}-api"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  timeouts {}
  tags = {
    Service = var.service
  }
}

resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        selection = {
          tagStatus = "any"
          countType = "imageCountMoreThan"
          countNumber : 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
