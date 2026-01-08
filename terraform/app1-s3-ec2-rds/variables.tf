variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "allowed_http_port" {
  type    = number
  default = 80
}

variable "allowed_rdp_cidr" {
  type = string
}

variable "rds_access_cidr" {
  type = string
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
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
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
  default = "mydatabase"
}

variable "manage_rds" {
  type    = bool
  default = true
}

variable "enable_ec2" {
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

variable "key_name" {
  type = string
}

variable "user_data_script" {
  type    = string
  default = ""
}

variable "ami_filter_name" {
  type    = string
  default = "Windows_Server-*-English-*-Core-Base*"
}

variable "enable_s3_website" {
  type    = bool
  default = true
}

variable "s3_bucket_name" {
  type = string
}