variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., sandbox/dev/prod)."
  type        = string
  default     = "sandbox"
}

variable "my_ip_cidr" {
  description = "Your public IP with CIDR suffix for RDP access."
  type        = string
  default     = "0.0.0.0/0"
}

# Feature toggles (used by GitHub Actions -var flags)
variable "enable_ec2" {
  description = "If true, create backend EC2 resources."
  type        = bool
  default     = true
}

variable "enable_s3_website" {
  description = "If true, create S3 static website resources."
  type        = bool
  default     = true
}

# AMI ID (avoids DescribeImages permission requirement)
variable "windows_ami_id" {
  description = "Windows Server AMI ID used for the backend instance."
  type        = string
  default     = "ami-0f6d3d1de3c02ee19"
}

variable "ec2_instance_type" {
  description = "Backend EC2 instance type."
  type        = string
  default     = "t3.medium"
}

variable "ec2_key_name" {
  description = "EC2 key pair name for RDP access."
  type        = string
  default     = "keypair-vpc1"
}

# RDS settings
variable "db_instance_identifier" {
  description = "Identifier for the RDS instance."
  type        = string
  default     = "cloud495"
}

variable "db_name" {
  description = "Database name."
  type        = string
  default     = "cloud495"
}

# Preferred naming
variable "db_username" {
  description = "RDS master username (preferred key)."
  type        = string
  default     = ""
}

variable "db_password" {
  description = "RDS master password (preferred key)."
  type        = string
  sensitive   = true
  default     = ""
}

# Legacy naming (matches your warnings)
variable "db_master_username" {
  description = "RDS master username (legacy tfvars key)."
  type        = string
  default     = ""
}

variable "db_master_password" {
  description = "RDS master password (legacy tfvars key)."
  type        = string
  sensitive   = true
  default     = ""
}

# S3
variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name for frontend website."
  type        = string
  default     = "nealb03-frontend-bucket-unique-2887"
}

# AZs
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