variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "enable_ec2" {
  description = "Whether to create EC2 instances (true/false)"
  type        = bool
  default     = true
}

variable "enable_s3_website" {
  description = "Whether to create S3 website bucket (true/false)"
  type        = bool
  default     = true
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP CIDR for security group ingress"
  type        = string
}