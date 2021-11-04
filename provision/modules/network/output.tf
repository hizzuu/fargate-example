output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "ingress_subnet_ids" {
  value = module.ingress_subnet.subnet_ids
}

output "backend_subnet_ids" {
  value = module.backend_subnet.subnet_ids
}

output "rds_subnet_ids" {
  value = module.rds_subnet.subnet_ids
}

output "ingress_security_group_id" {
  value = aws_security_group.ingress.id
}

output "backend_security_group_id" {
  value = aws_security_group.backend.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
