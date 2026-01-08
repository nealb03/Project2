terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "app_stack" {
  source = "../modules/app_stack"

  # Pass only variables that app_stack expects (matching names)
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones

  allowed_http_port    = var.allowed_http_port
  allowed_rdp_cidr     = var.allowed_rdp_cidr
  rds_access_cidr      = var.rds_access_cidr

  db_master_username   = var.db_master_username
  db_master_password   = var.db_master_password
  db_identifier        = var.db_identifier
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name
  manage_rds           = var.manage_rds

  enable_ec2           = var.enable_ec2
  instance_type        = var.instance_type
  subnet_id_for_ec2    = var.subnet_id_for_ec2
  associate_public_ip  = var.associate_public_ip
  key_name             = var.key_name
  user_data_script     = var.user_data_script
  ami_filter_name      = var.ami_filter_name

  enable_s3_website    = var.enable_s3_website
  s3_bucket_name       = var.s3_bucket_name
}