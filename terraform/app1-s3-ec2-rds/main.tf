terraform {
  required_version = ">=1.0"
}

provider "aws" {
  region = var.aws_region
}

module "app_stack" {
  source = "../modules/app_stack"

  # Only pass variables declared in app_stack/variables.tf
  my_ip_cidr        = var.my_ip_cidr

  enable_ec2        = var.enable_ec2
  enable_s3_website = var.enable_s3_website
  key_name          = var.key_name
  s3_bucket_name    = var.s3_bucket_name

  db_master_username = var.db_master_username
  db_master_password = var.db_master_password
}