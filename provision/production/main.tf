terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    bucket  = "tf-state-sample"
    key     = "production/terraform.tfstate"
    encrypt = true
    dynamodb_table = "tf-state-lock-sample"
  }
}

provider "aws" {
}

module "s3" {
  source = "../modules/s3"
}

module "dynamo" {
  source = "../modules/dynamo"
}

module "network" {
  source = "../modules/network"
}