variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment for the project (e.g., dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

#----------------VPC----------------

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
}

variable "az_count" {
  description = "availability zones"
  type        = number
}

variable "instance_type" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "lifecycle_days" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "alert_email" {
  type = string
}