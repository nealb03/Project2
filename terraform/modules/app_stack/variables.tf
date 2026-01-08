variable "my_ip_cidr" {
  type = string
}

variable "enable_ec2" {
  type = bool
}

variable "enable_s3_website" {
  type = bool
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
  type = string
}