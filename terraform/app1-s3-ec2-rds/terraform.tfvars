# AWS region
aws_region = "us-east-1"

# Your public IP CIDR block used for RDP access in security groups
my_ip_cidr = "203.0.113.25/32"

# VPC and subnet CIDRs (if you make these configurable as variables)
vpc_cidr = "10.0.0.0/16"
public_subnet_a_cidr = "10.0.1.0/24"
public_subnet_b_cidr = "10.0.2.0/24"

# EC2 details
key_name           = "keypair-vpc1"
instance_type      = "t3.medium"
associate_public_ip = true

# RDS database parameters
db_identifier       = "cloud495"
db_engine           = "mysql"
db_engine_version   = "8.0.40"
db_instance_class   = "db.t3.micro"
db_allocated_storage = 20
db_master_username  = "admin"
db_master_password  = "password"
db_name             = "cloud495"

# S3 bucket name for frontend static website
s3_bucket_name      = "nealb03-frontend-bucket-unique-2887"

# Enable flags
enable_ec2          = true
enable_s3_website   = true