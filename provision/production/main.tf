# off

terraform {
  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "tf-state-sample"
    key            = "production/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "tf-state-lock-sample-db"
  }
}

provider "aws" {
}

module "s3" {
  source  = "../modules/s3"
  service = var.service
}

module "dynamo" {
  source  = "../modules/dynamo"
  service = var.service
}

module "network" {
  source  = "../modules/network"
  service = var.service
  vpc_cidr        = var.vpc_cidr
  region          = var.region
  ingress_subnets = var.ingress_subnets
  backend_subnets = var.backend_subnets
  rds_subnets     = var.rds_subnets
}

module "alb" {
  source          = "../modules/alb"
  service         = var.service
  vpc_id          = module.network.vpc_id
  security_groups = [module.network.ingress_security_group_id]
  subnets         = module.network.ingress_subnet_ids
  log_bucket      = module.s3.log_bucket_name
}

module "ecr" {
  source  = "../modules/ecr"
  service = var.service
}

module "ecs" {
  source                                = "../modules/ecs"
  region                                = var.region
  service                               = var.service
  subnets                               = module.network.backend_subnet_ids
  security_groups                       = [module.network.backend_security_group_id]
  fargate_capacity_provider_base        = var.fargate_capacity_provider_base
  fargate_capacity_provider_weight      = var.fargate_capacity_provider_weight
  fargate_spot_capacity_provider_base   = var.fargate_spot_capacity_provider_base
  fargate_spot_capacity_provider_weight = var.fargate_spot_capacity_provider_weight
  fargate_task_definition_cpu           = var.fargate_task_definition_cpu
  fargate_task_definition_memory        = var.fargate_task_definition_memory
  task_role_policy_arns                 = []
  repository_arns                       = module.ecr.repository_arns
  api_target_group_arn                  = module.alb.target_group_arn
  api_image                             = "${module.ecr.api_url}:latest"
  api_cpu                               = var.fargate_api_cpu
  api_memory                            = var.fargate_api_memory
  api_container_port                    = var.fargate_api_container_port
  api_environments                      = var.fargate_api_environments
}
