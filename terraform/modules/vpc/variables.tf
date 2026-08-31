variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment for the project (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
}

variable "az_count" {
  description = "availability zones"
  type        = number
}