variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "demo"
}

variable "my_ip_cidr" {
  description = "Your public IP with CIDR suffix for RDP access."
  type        = string
}

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

variable "enable_rds" {
  description = "If true, create/manage a new RDS instance."
  type        = bool
  default     = false
}

variable "existing_vpc_id" {
  description = "ID of the existing VPC to deploy resources into."
  type        = string
}

variable "existing_public_subnet_ids" {
  description = "List of existing public subnet IDs (at least 2)."
  type        = list(string)

  validation {
    condition     = length(var.existing_public_subnet_ids) >= 2
    error_message = "existing_public_subnet_ids must contain at least two subnet IDs."
  }
}

variable "existing_db_subnet_group_name" {
  description = "Existing DB subnet group name (only used when enable_rds=true)."
  type        = string
  default     = ""
}

variable "windows_ami_id" {
  description = "Windows Server AMI ID."
  type        = string
}

variable "ec2_instance_type" {
  description = "Backend EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "EC2 key pair name for RDP access."
  type        = string
}

variable "existing_rds_identifier" {
  description = "Existing RDS DB instance identifier from the RDS console. Leave blank to skip lookup."
  type        = string
  default     = ""
}

variable "db_instance_identifier" {
  description = "Identifier for the new RDS instance (enable_rds=true only)."
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Database name to create inside new RDS (enable_rds=true only)."
  type        = string
  default     = ""
}

variable "db_username" {
  description = "New RDS master username (preferred key)."
  type        = string
  default     = ""
}

variable "db_password" {
  description = "New RDS master password (preferred key)."
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_master_username" {
  description = "New RDS master username (legacy key)."
  type        = string
  default     = ""
}

variable "db_master_password" {
  description = "New RDS master password (legacy key)."
  type        = string
  sensitive   = true
  default     = ""
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name for frontend website."
  type        = string
}

variable "az_a" {
  description = "Availability zone A (legacy/compatibility)."
  type        = string
  default     = "us-east-1a"
}

variable "az_b" {
  description = "Availability zone B (legacy/compatibility)."
  type        = string
  default     = "us-east-1b"
}