variable "service" {
  default = "fargate-sample"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "ingress_subnets" {
  default = {
    "10.0.0.0/24" = "ap-northeast-1a",
    "10.0.1.0/24" = "ap-northeast-1c",
  }
}

variable "backend_subnets" {
  default = {
    "10.0.2.0/24" = "ap-northeast-1a",
    "10.0.3.0/24" = "ap-northeast-1c",
  }
}

variable "rds_subnets" {
  default = {
    "10.0.4.0/24" = "ap-northeast-1a",
    "10.0.5.0/24" = "ap-northeast-1c",
  }
}

variable "fargate_capacity_provider_base" {
  default = 0
}

variable "fargate_capacity_provider_weight" {
  default = 1
}

variable "fargate_spot_capacity_provider_base" {
  default = 1
}

variable "fargate_spot_capacity_provider_weight" {
  default = 5
}

variable "fargate_task_definition_cpu" {
  default = 512
}

variable "fargate_task_definition_memory" {
  default = 1024
}

variable "fargate_api_cpu" {
  default = 256
}

variable "fargate_api_memory" {
  default = 512
}

variable "fargate_api_container_port" {
  default = 8080
}

variable "fargate_api_environments" {
  default = [
    {
      name  = "ENV"
      value = "prod"
    },
  ]
}
