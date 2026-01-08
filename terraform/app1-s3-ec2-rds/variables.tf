variable "aws_region" {
  type    = string
  default = "us-east-1"
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
}

variable "db_master_username" {
  type = string
}

variable "db_master_password" {
  type      = string
  sensitive = true
}