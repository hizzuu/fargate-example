resource "aws_subnet" "private" {
  for_each          = var.subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = each.value
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = var.service
    Service     = var.service
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = var.service
    Service     = var.service
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
  lifecycle {
    create_before_destroy = true
  }
}
