terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# Call consolidated app_stack module only once
module "app_stack" {
  source = "../modules/app_stack"

  environment       = var.environment
  aws_region        = var.aws_region
  enable_ec2        = var.enable_ec2
  enable_s3_website = var.enable_s3_website

  db_username       = var.db_username
  db_password       = var.db_password
  s3_bucket_name    = var.s3_bucket_name
  key_name          = var.key_name
  my_ip_cidr        = var.my_ip_cidr

  # Add any other required variables your module expects
}