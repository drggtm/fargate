variable "name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "container_port" {
  type = number
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}
