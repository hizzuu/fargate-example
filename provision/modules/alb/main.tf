resource "aws_lb" "default" {
  name               = "${var.service}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  access_logs {
    bucket  = var.log_bucket
    prefix  = "${var.service}-alb"
    enabled = true
  }
  tags = {
    Service     = var.service
  }
}

resource "aws_lb_target_group" "default" {
  name        = "${var.service}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path     = "/v1/healthcheck"
    matcher  = 200
    interval = 60
  }
  tags = {
    Service     = var.service
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.default.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
  tags = {
    Service     = var.service
  }
}
