resource "aws_iam_role" "task_role" {
  name = "${var.service}-ecs-task"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ssm.amazonaws.com"
        },
      }
    ]
  })
  tags = {
    Service     = var.service
  }
}

resource "aws_iam_role_policy_attachment" "task_role" {
  for_each   = var.task_role_policy_arns
  role       = aws_iam_role.task_role.name
  policy_arn = each.value
}

resource "aws_iam_role" "task_exec_role" {
  name = "${var.service}-ecs-task-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
  tags = {
    Service = var.service
  }
}

resource "aws_iam_policy" "container_registry_read" {
  name = "${var.service}-container-registry-read"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = var.repository_arns
      },
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_exec_role_container_registry_read" {
  role       = aws_iam_role.task_exec_role.name
  policy_arn = aws_iam_policy.container_registry_read.arn
}

resource "aws_iam_role_policy_attachment" "task_exec_role_cloudwatch_logs" {
  role       = aws_iam_role.task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_ecs_cluster" "default" {
  name               = "${var.service}"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = var.fargate_capacity_provider_base
    capacity_provider = "FARGATE"
    weight            = var.fargate_capacity_provider_weight
  }
  default_capacity_provider_strategy {
    base              = var.fargate_spot_capacity_provider_base
    capacity_provider = "FARGATE_SPOT"
    weight            = var.fargate_spot_capacity_provider_weight
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Service     = var.service
  }
}

resource "aws_cloudwatch_log_group" "ecs_log" {
  name              = "/ecs/${var.service}-backend"
  retention_in_days = 180
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.service}-backend"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_task_definition_cpu
  memory                   = var.fargate_task_definition_memory
  container_definitions = jsonencode([
    {
      name        = "api"
      image       = var.api_image
      cpu         = var.api_cpu
      memory      = var.api_memory
      mountPoints = []
      portMappings = [
        {
          containerPort = var.api_container_port
          hostPort      = var.api_container_port
          protocol      = "tcp"
        }
      ]
      volumesFrom = []
      essential   = true
      environment = var.api_environments
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
  ])
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_exec_role.arn
  network_mode       = "awsvpc"
  tags = {
    Service     = var.service
  }
}

resource "aws_ecs_service" "backend" {
  name            = "api"
  cluster         = aws_ecs_cluster.default.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.backend.arn
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = "true"
  }
  load_balancer {
    target_group_arn = var.api_target_group_arn
    container_name   = "api"
    container_port   = var.api_container_port
  }
  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}
