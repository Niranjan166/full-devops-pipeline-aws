variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_id" {
  type = string
}

variable "db_instance_identifier" {
  description = "Identifier of the RDS instance"
  type        = string
}

variable "alert_email" {
  description = "email address for cloudwatch alert notification"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization threshold for CloudWatch alarm"
  type        = number
  default     = 80
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}