terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "my_ip_cidr" {
  description = "CIDR block for RDP access"
  type        = string
  default     = "0.0.0.0/0"
}

##########################################
# Module: Network (VPC and Subnets setup)
##########################################
module "network" {
  source = "../modules/app_stack/network"

  vpc_cidr          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  enable_nat_gateway  = false
}

##########################################
# Module: Security Groups
##########################################
module "security_groups" {
  source = "../modules/app_stack/security_groups"

  vpc_id    = module.network.vpc_id
  allowed_rdp_cidr = var.my_ip_cidr

  # Allow HTTP 80 open for backend ec2
  backend_http_port = 80
  # Allow MySQL access for RDS from any IPv4 (placeholder)
  rds_access_cidr = "0.0.0.0/0"
}

##########################################
# Module: RDS (shared for app1 & app2)
##########################################
module "rds" {
  source = "../modules/app_stack/rds"

  db_identifier          = "cloud495"
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  master_username        = var.db_username
  master_password        = var.db_password
  db_name                = "cloud495"

  vpc_id                 = module.network.vpc_id
  subnet_ids             = module.network.public_subnet_ids
  vpc_security_group_ids = [module.security_groups.rds_sg_id]
  publicly_accessible    = true

  multi_az               = false
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  sensitive = true
  default = "password"
}

##########################################
# Module: Backend EC2
##########################################
module "backend_ec2" {
  source = "../modules/app_stack/ec2"

  ami_filter_name      = "Windows_Server-2019-English-Full-Base-*"
  instance_type       = "t3.medium"
  subnet_id           = module.network.public_subnet_ids[0]
  vpc_security_group_ids = [module.security_groups.backend_sg_id]
  key_name            = "keypair-vpc1"

  user_data_script    = file("userdata_windows_backend.ps1")
  associate_public_ip = true
}

##########################################
# Module: Frontend S3 Hosting
##########################################
module "frontend_s3" {
  source = "../modules/app_stack/s3_website"

  bucket_name = "nealb03-frontend-bucket-unique-2887-demo"
  enable_public_access = true
}

############################
# OUTPUTS
############################

output "backend_public_ip" {
  description = "Backend EC2 Public IP"
  value       = module.backend_ec2.public_ip
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.endpoint
}

output "s3_website_endpoint" {
  description = "Frontend S3 Website URL"
  value       = module.frontend_s3.website_endpoint
}