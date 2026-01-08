variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "allowed_http_port" {
  type    = number
  default = 80
}

variable "my_ip_cidr" {
  type = string
}

variable "enable_ec2" {
  type    = bool
  default = true
}

variable "enable_s3_website" {
  type    = bool
  default = true
}

variable "key_name" {
  type = string
}

variable "s3_bucket_name" {
  type = string
  default = ""
}

variable "db_master_username" {
  type = string
}

variable "db_master_password" {
  type      = string
  sensitive = true
}

variable "db_identifier" {
  type = string
  default = "cloud495"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0.40"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "cloud495"
}

variable "manage_rds" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "subnet_id_for_ec2" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "user_data_script" {
  type    = string
  default = ""
}

variable "ami_filter_name" {
  type    = string
  default = "Windows_Server-*-English-*-Core-Base*"
}