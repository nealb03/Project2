variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., sandbox, dev, prod)."
  type        = string
  default     = "sandbox"
}

variable "my_ip_cidr" {
  description = "Your public IP with CIDR suffix for RDP access (e.g. 203.0.113.10/32)."
  type        = string
  default     = "0.0.0.0/0"
}

# Feature toggles (these are the ones your GitHub Action passes via -var)
variable "enable_ec2" {
  description = "If true, create the backend EC2 instance (and its security group)."
  type        = bool
  default     = true
}

variable "enable_s3_website" {
  description = "If true, create the S3 static website resources."
  type        = bool
  default     = true
}

# RDS settings (so terraform.tfvars values are declared and no longer warn)
variable "db_name" {
  description = "Database name for the RDS instance."
  type        = string
  default     = "cloud495"
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the RDS instance."
  type        = string
  sensitive   = true
  default     = "password"
}

variable "db_instance_identifier" {
  description = "Identifier for the RDS instance."
  type        = string
  default     = "cloud495"
}

# S3 settings (so terraform.tfvars values are declared and no longer warn)
variable "s3_bucket_name" {
  description = "Globally-unique S3 bucket name for frontend website."
  type        = string
  default     = "nealb03-frontend-bucket-unique-2887"
}

# EC2 settings
variable "ec2_instance_type" {
  description = "Instance type for backend EC2."
  type        = string
  default     = "t3.medium"
}

variable "ec2_key_name" {
  description = "EC2 key pair name for RDP access."
  type        = string
  default     = "keypair-vpc1"
}

# Networking / AZs
variable "az_a" {
  description = "Availability zone A."
  type        = string
  default     = "us-east-1a"
}

variable "az_b" {
  description = "Availability zone B."
  type        = string
  default     = "us-east-1b"
}