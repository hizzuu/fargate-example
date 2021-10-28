resource "aws_subnet" "public" {
  for_each                = var.subnets
  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = var.service
    Service     = var.service
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }
  tags = {
    Name        = var.service
    Service     = var.service
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
