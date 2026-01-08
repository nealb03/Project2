variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "enable_ec2" {
  description = "Create EC2 resources"
  type        = bool
  default     = true
}

variable "enable_s3_website" {
  description = "Create S3 website bucket"
  type        = bool
  default     = true
}

variable "db_username" {
  description = "RDS DB username"
  type        = string
}

variable "db_password" {
  description = "RDS DB password"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "S3 bucket name for website"
  type        = string
}

variable "key_name" {
  description = "Name of EC2 key pair"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP CIDR for security group ingress"
  type        = string
}