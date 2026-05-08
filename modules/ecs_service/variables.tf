variable "name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "autoscaling_min_capacity" {
  type = number
}

variable "autoscaling_max_capacity" {
  type = number
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "secret_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}
