variable "name_prefix" {
  description = "Prefix used for naming endpoint resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the endpoints will be created."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR; used to allow endpoint traffic from inside the VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets that interface endpoints will be deployed into."
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Private route tables that the S3 gateway endpoint will attach to."
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region used to build endpoint service names."
  type        = string
}
