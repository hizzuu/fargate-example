output "subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "subnets" {
  value = aws_subnet.private
}
