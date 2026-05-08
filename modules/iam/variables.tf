variable "name_prefix" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "secret_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}
