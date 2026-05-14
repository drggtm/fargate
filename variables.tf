variable "project_name" {
  description = "Prefix used for naming AWS resources."
  type        = string
  default     = "hello-fargate"
}

variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "container_image" {
  description = "Container image to run on ECS."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Fargate CPU units for the task."
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096, 8192, 16384], var.cpu)
    error_message = "cpu must be a valid AWS Fargate CPU value."
  }
}

variable "memory" {
  description = "Fargate memory (MiB) for the task."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Initial number of ECS tasks to run before autoscaling adjusts capacity."
  type        = number
  default     = 2
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS service task count."
  type        = number
  default     = 2
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS service task count."
  type        = number
  default     = 4
}

variable "health_check_path" {
  description = "HTTP path used by the ALB target group health check."
  type        = string
  default     = "/"
}

variable "nat_gateway_mode" {
  description = "Use a single NAT Gateway for lower cost or one NAT Gateway per AZ for higher availability."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either \"single\" or \"per_az\"."
  }
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 30
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the CI deployment role"
  type        = string
  default     = "drggtm/fargate"
}

variable "enable_waf" {
  description = "Attach an AWS WAFv2 Web ACL with managed rule groups to the ALB."
  type        = bool
  default     = true
}
