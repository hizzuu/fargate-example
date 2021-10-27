variable "subnets" {
  default = {
    "10.0.1.0/24" = "ap-northeast-1a",
    "10.0.2.0/24" = "ap-northeast-1c",
  }
}

variable "vpc_id" {}
variable "gateway_id" {}
