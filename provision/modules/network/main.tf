module "vpc" {
  source      = "./vpc"
  service = var.service
}

resource "aws_internet_gateway" "public" {
  vpc_id = module.vpc.vpc_id
}

module "public_subnet" {
  source      = "./public_subnet"
  service = var.service
  vpc_id      = module.vpc.vpc_id
  gateway_id  = aws_internet_gateway.public.id
}

module "private_subnet" {
  source      = "./private_subnet"
  service = var.service
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "backend" {
  vpc_id      = module.vpc.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks       = [for subnet in module.public_subnet.subnets : subnet.cidr_block]
    self              = false
    ipv6_cidr_blocks  = []
    prefix_list_ids   = []
  }
}