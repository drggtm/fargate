variable "name_prefix" {
  description = "Prefix used for alarm and topic names."
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB (used as the LoadBalancer dimension on AWS/ApplicationELB metrics)."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the ALB target group (used as the TargetGroup dimension)."
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name for ECS service metrics."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name for ECS service metrics."
  type        = string
}

variable "desired_count" {
  description = "Expected running task count; running below this triggers the crash-loop alarm."
  type        = number
}

variable "alarm_email_addresses" {
  description = "Optional list of email addresses to subscribe to the alarm SNS topic."
  type        = list(string)
  default     = []
}

variable "alb_5xx_threshold" {
  description = "Total 5xx responses (per minute) before the ALB alarm fires."
  type        = number
  default     = 5
}
