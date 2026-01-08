variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "enable_ec2" {
  description = "Whether to create EC2 resources"
  type        = bool
  default     = true
}

variable "enable_s3_website" {
  description = "Whether to create an S3 website bucket"
  type        = bool
  default     = true
}

variable "db_master_username" {
  description = "RDS master username"
  type        = string
}

variable "db_master_password" {
  description = "RDS master password"
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
  description = "IP CIDR for security group ingress"
  type        = string
}