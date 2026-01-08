variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "my_ip_cidr" {
  description = "CIDR block allowed for RDP (optional)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_endpoint" {
  description = "RDS database endpoint from app1"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "RDS username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "container_image" {
  description = "Docker image URI for Fargate task"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port exposed by container"
  type        = number
  default     = 80
}