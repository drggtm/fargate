variable "name_prefix" {
  description = "Prefix for WAF resource names."
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer to associate with the Web ACL."
  type        = string
}

variable "log_retention_in_days" {
  description = "CloudWatch retention in days for WAF logs."
  type        = number
  default     = 30
}
