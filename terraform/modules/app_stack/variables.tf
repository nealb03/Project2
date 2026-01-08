variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "allowed_http_port" {
  description = "Allowed HTTP port"
  type        = number
  default     = 80
}

variable "allowed_rdp_cidr" {
  description = "CIDR block allowed to access EC2 RDP port"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rds_access_cidr" {
  description = "CIDR block allowed to access RDS MySQL port"
  type        = string
  default     = "0.0.0.0/0"
}

variable "manage_rds" {
  description = "True to create and manage RDS in this module"
  type        = bool
  default     = true
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "cloud495"
}

variable "db_engine" {
  description = "RDS engine type"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0.40"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_master_username" {
  description = "RDS master username"
  type        = string
}

variable "db_master_password" {
  description = "RDS master password"
  sensitive   = true
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "cloud495"
}

# EC2-related variables, will be referenced only when app requires EC2
variable "enable_ec2" {
  description = "Control whether EC2 instance should be created"
  type        = bool
  default     = true
}

variable "ami_filter_name" {
  description = "AMI filter name pattern for EC2"
  type        = string
  default     = "Windows_Server-2019-English-Full-Base-*"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id_for_ec2" {
  description = "Subnet ID to launch EC2 instance"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Key name for SSH/RDP to EC2"
  type        = string
  default     = ""
}

variable "user_data_script" {
  description = "User data script for EC2 instance"
  type        = string
  default     = ""
}

variable "associate_public_ip" {
  description = "Assign public IP to EC2 instance"
  type        = bool
  default     = true
}

# S3-related variables 
variable "enable_s3_website" {
  description = "Control whether to create S3 bucket static website hosting"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "Name of S3 bucket to create for website"
  type        = string
  default     = ""
}