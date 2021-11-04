module "vpc" {
  source  = "./vpc"
  service = var.service
  cidr    = var.vpc_cidr
}

resource "aws_internet_gateway" "public" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Service     = var.service
  }
}

module "ingress_subnet" {
  source      = "./public_subnet"
  service     = var.service
  vpc_id      = module.vpc.vpc_id
  subnets     = var.ingress_subnets
  gateway_id  = aws_internet_gateway.public.id
}

module "backend_subnet" {
  source      = "./public_subnet"
  service     = "${var.service}-backend"
  vpc_id      = module.vpc.vpc_id
  subnets     = var.backend_subnets
  gateway_id  = aws_internet_gateway.public.id
}

module "rds_subnet" {
  source      = "./private_subnet"
  service     = var.service
  vpc_id      = module.vpc.vpc_id
  subnets     = var.rds_subnets
}

resource "aws_network_acl" "acl" {
  vpc_id = module.vpc.vpc_id
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Service     = var.service
  }
}

resource "aws_security_group" "ingress" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.service}-ingress"
  tags = {
    Service     = var.service
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_ingress_http_ipv4" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "ingress_ingress_http_ipv6" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ingress.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_ingress_https_ipv4" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_ingress_https_ipv6" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ingress.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.service}-backend"
  vpc_id      = module.vpc.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "backend_ingress_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [for subnet in module.ingress_subnet.subnets : subnet.cidr_block]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.backend.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "backend_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.service}-rds"
  description = "${var.service}-rds"
  tags = {
    Name        = "${var.service}-rds"
    Service     = var.service
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [for subnet in module.backend_subnet.subnets : subnet.cidr_block]
  security_group_id = aws_security_group.rds.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
  lifecycle {
    create_before_destroy = true
  }
}
