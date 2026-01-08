terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "app_stack" {
  source = "../modules/app_stack"

  # Pass only the variables that app_stack module defines:
  enable_ec2        = var.enable_ec2
  enable_s3_website = var.enable_s3_website

  db_master_username = var.db_master_username
  db_master_password = var.db_master_password

  # Add other variables matching exactly your app_stack module variable names:

  s3_bucket_name = var.s3_bucket_name
  key_name       = var.key_name
  my_ip_cidr     = var.my_ip_cidr
}