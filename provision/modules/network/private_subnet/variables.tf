variable "service" {}

variable "subnets" {
  default = {
    "10.0.3.0/24" = "ap-northeast-1a",
    "10.0.4.0/24" = "ap-northeast-1c",
  }
}

variable "vpc_id" {}