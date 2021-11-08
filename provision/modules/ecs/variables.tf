variable "region" {
  type = string
}

variable "service" {
  type = string
}

variable "fargate_capacity_provider_base" {
  type = number
}

variable "fargate_capacity_provider_weight" {
  type = number
}

variable "fargate_spot_capacity_provider_base" {
  type = number
}

variable "fargate_spot_capacity_provider_weight" {
  type = number
}

variable "fargate_task_definition_cpu" {
  type = number
}

variable "fargate_task_definition_memory" {
  type = number
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "repository_arns" {
  type = list(string)
}

variable "task_role_policy_arns" {
  type = set(string)
}

variable "api_target_group_arn" {
  type = string
}

variable "api_image" {
  type = string
}

variable "api_cpu" {
  type = number
}

variable "api_memory" {
  type = number
}

variable "api_container_port" {
  type = number
}

variable "api_environments" {}

variable "api_secrets" {}