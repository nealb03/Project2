###############################################################################
# MODULE-BASED DEMO (COMMENTED OUT)
# Purpose: Demonstrate how this app1 root module could be refactored into
# reusable Terraform modules under ../modules/* without breaking the current app.
#
# IMPORTANT:
# - Everything below is commented out; it has ZERO effect on your current stack.
# - If you ever decide to migrate, uncomment one module at a time and delete the
#   overlapping "resource" blocks above.
###############################################################################

# -----------------------------------------------------------------------------
# Suggested module split for App1 (for interview/demo)
#   ../modules/network         -> VPC, IGW, public subnets, public route table
#   ../modules/security-group  -> backend SG + db SG
#   ../modules/rds             -> DB subnet group + DB instance
#   ../modules/ec2-backend     -> Windows EC2 + user_data + optional key pair usage
#   ../modules/s3-website      -> S3 bucket + public access block + policy + website config
#
# Your repo currently shows some of these modules (network, security-group, rds).
# The others (ec2-backend, s3-website) can be “future module ideas” in the demo.
# -----------------------------------------------------------------------------

# locals {
#   # Keep your existing local credential logic (copied conceptually)
#   db_username_candidate        = var.db_username != "" ? var.db_username : null
#   db_master_username_candidate = var.db_master_username != "" ? var.db_master_username : null
#
#   db_password_candidate        = var.db_password != "" ? var.db_password : null
#   db_master_password_candidate = var.db_master_password != "" ? var.db_master_password : null
#
#   effective_db_username = coalesce(
#     local.db_username_candidate,
#     local.db_master_username_candidate,
#     "cloud-495",
#   )
#
#   effective_db_password = coalesce(
#     local.db_password_candidate,
#     local.db_master_password_candidate,
#     "password",
#   )
#
#   name_prefix = "app1-${var.environment}"
#
#   common_tags = {
#     Application = "app1"
#     Environment = var.environment
#     ManagedBy   = "terraform"
#   }
# }

# -----------------------------------------------------------------------------
# NETWORK MODULE (instead of aws_vpc + igw + public subnets + public route table)
# -----------------------------------------------------------------------------
# module "network" {
#   source      = "../modules/network"
#   name_prefix = local.name_prefix
#
#   # If your network module uses a single CIDR and az_count:
#   vpc_cidr = "10.0.0.0/16"
#   az_count = 2
#
#   # If your module supports tags:
#   tags = local.common_tags
# }
#
# # If you need deterministic subnet selection like “public_subnet_a/b”, you can
# # use indexing:
# # local.public_subnet_a_id = module.network.public_subnet_ids[0]
# # local.public_subnet_b_id = module.network.public_subnet_ids[1]

# -----------------------------------------------------------------------------
# SECURITY GROUP MODULE
# NOTE: Your existing app1 has TWO SGs:
# - backend_sg (conditional on enable_ec2)
# - rds_sg (always)
#
# A module can still support conditional creation, but for demo purposes you can
# either:
#  (A) keep EC2 SG as a resource in root, or
#  (B) create a dedicated module that supports enable_ec2.
# Below is a demo showing a generic module approach.
# -----------------------------------------------------------------------------
# module "security_group" {
#   source      = "../modules/security-group"
#   name_prefix = local.name_prefix
#   vpc_id      = module.network.vpc_id
#
#   # app1 uses HTTP 80 and RDS MySQL 3306
#   container_port = 80
#   db_port        = 3306
#
#   tags = local.common_tags
# }
#
# # For demo mapping:
# # local.backend_sg_id = module.security_group.ecs_sg_id  # (rename output in your module if you want)
# # local.rds_sg_id     = module.security_group.db_sg_id

# -----------------------------------------------------------------------------
# RDS MODULE (instead of aws_db_subnet_group + aws_db_instance)
# NOTE: Your current app1 uses PUBLIC subnets for a demo DB (publicly_accessible=true)
# The sample rds module we discussed earlier is more “private-subnet” oriented.
# For a demo, you can still show wiring and explain you'd adjust module flags:
#   publicly_accessible, subnet_ids selection, etc.
# -----------------------------------------------------------------------------
# module "rds" {
#   source      = "../modules/rds"
#   name_prefix = local.name_prefix
#
#   # For your current behavior (public demo DB):
#   # If you enhance the rds module later, pass "subnet_ids" instead of "private_subnet_ids"
#   # subnet_ids = module.network.public_subnet_ids
#
#   # If your rds module expects private subnets, show best practice wiring:
#   private_subnet_ids = module.network.private_subnet_ids
#
#   # Map SG output
#   db_sg_id = module.security_group.db_sg_id
#
#   db_name         = var.db_name
#   master_username = local.effective_db_username
#   master_password = local.effective_db_password
#
#   tags = local.common_tags
# }

# -----------------------------------------------------------------------------
# EC2 BACKEND MODULE (future demo idea)
# You currently have enable_ec2 and a Windows user_data bootstrap.
# This is a great candidate for a module, but you may not have created it yet.
# -----------------------------------------------------------------------------
# module "ec2_backend" {
#   source      = "../modules/ec2-backend"
#   count       = var.enable_ec2 ? 1 : 0
#
#   name_prefix  = local.name_prefix
#   subnet_id    = module.network.public_subnet_ids[0]
#   sg_id        = module.security_group.ecs_sg_id
#
#   ami_id       = var.windows_ami_id
#   instance_type= var.ec2_instance_type
#   key_name     = var.ec2_key_name
#   my_ip_cidr   = var.my_ip_cidr
#
#   tags = local.common_tags
# }

# -----------------------------------------------------------------------------
# S3 WEBSITE MODULE (future demo idea)
# You currently have enable_s3_website and several bucket resources.
# This is also a clean module candidate.
# -----------------------------------------------------------------------------
# module "s3_website" {
#   source      = "../modules/s3-website"
#   count       = var.enable_s3_website ? 1 : 0
#
#   bucket_name = var.s3_bucket_name
#   tags        = local.common_tags
# }