output "subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "subnets" {
  value = aws_subnet.public
}
