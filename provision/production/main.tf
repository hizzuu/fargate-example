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
  source = "../modules/s3"
  service = var.service
}

module "dynamo" {
  source = "../modules/dynamo"
  service = var.service
}

module "network" {
  source = "../modules/network"
  service = var.service
}

module "alb" {
  source = "../modules/alb"
  service = var.service
  vpc_id = module.network.vpc_id
  security_groups = [ module.network.backend_security_group_id ]
  subnets = module.network.backend_subnet_ids
  log_bucket = module.s3.log_bucket_name
}

module "ecr" {
  source  = "../modules/ecr"
  service = var.service
}
