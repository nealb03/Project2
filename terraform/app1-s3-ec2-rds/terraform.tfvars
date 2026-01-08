############################################
# Core settings
############################################

aws_region  = "us-east-1"
environment = "sandbox"

# Your public IP CIDR block for RDP access
my_ip_cidr = "203.0.113.25/32"

############################################
# Feature toggles (also set by GitHub Actions -var)
############################################

enable_ec2        = true
enable_s3_website = true

############################################
# EC2 (Windows backend)
# IMPORTANT: avoids ec2:DescribeImages permission
############################################

windows_ami_id     = "ami-0f6d3d1de3c02ee19"
ec2_key_name       = "keypair-vpc1"
ec2_instance_type  = "t3.medium"

############################################
# RDS (MySQL)
# Use either db_username/db_password OR db_master_username/db_master_password
# This file uses the legacy names you already had.
############################################

db_instance_identifier = "cloud495"
db_name                = "cloud495"

db_master_username     = "admin"
db_master_password     = "password"

############################################
# S3 website
############################################

s3_bucket_name = "nealb03-frontend-bucket-unique-2887"

############################################
# AZs (optional; defaults match us-east-1)
############################################

az_a = "us-east-1a"
az_b = "us-east-1b"