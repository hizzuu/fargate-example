output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "backend_subnet_ids" {
  value = module.public_subnet.subnet_ids
}

output "backend_security_group_id" {
  value = aws_security_group.backend.id
}
