###############################################################################
# MODULE-BASED DEMO (COMMENTED OUT)
# Purpose: Demonstrate how this root module could be refactored to use reusable
# Terraform modules under ../modules/*.
#
# IMPORTANT:
# - Everything below is commented out so it will NOT affect your working app.
# - To try it later, uncomment gradually and remove overlapping resources above.
###############################################################################

# -----------------------------------------------------------------------------
# Module wiring notes (for interview/demo)
# - module.network outputs: vpc_id, public_subnet_ids, private_subnet_ids
# - module.security_group outputs: ecs_sg_id, db_sg_id (and optionally alb_sg_id)
# - module.rds outputs: db_endpoint/address, db_port
# - module.ecs_fargate_service creates: cluster, task definition, service
# - module.iam creates or reuses: task_execution_role_arn, task_role_arn
# -----------------------------------------------------------------------------

# terraform {
#   required_version = ">= 1.2.0"
#
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }

# locals {
#   # Standard naming for multi-env (example)
#   name_prefix = "app2-${var.environment}"
#
#   common_tags = {
#     Application = "app2"
#     Environment = var.environment
#     ManagedBy   = "terraform"
#   }
# }

# -----------------------------------------------------------------------------
# NETWORK MODULE (instead of aws_vpc, subnets, igw, route table, etc.)
# -----------------------------------------------------------------------------
# module "network" {
#   source      = "../modules/network"
#   name_prefix = local.name_prefix
#
#   # Replace with your existing values/vars
#   vpc_cidr = var.vpc_cidr
#
#   # If your module uses az_count, use that; if it uses explicit AZs/CIDRs, pass those
#   az_count = length(var.availability_zones)
#
#   tags = local.common_tags
# }

# -----------------------------------------------------------------------------
# SECURITY GROUP MODULE (instead of aws_security_group.ecs_tasks and rds)
# -----------------------------------------------------------------------------
# module "security_group" {
#   source      = "../modules/security-group"
#   name_prefix = local.name_prefix
#   vpc_id      = module.network.vpc_id
#
#   container_port = var.allowed_http_port
#   db_port        = 3306
#
#   tags = local.common_tags
# }

# -----------------------------------------------------------------------------
# RDS MODULE (instead of aws_db_subnet_group + aws_db_instance)
# NOTE: For real-world best practice, RDS should be in PRIVATE subnets and not
# publicly accessible. Your current code is a public demo; keep it as-is.
# -----------------------------------------------------------------------------
# module "rds" {
#   source      = "../modules/rds"
#   name_prefix = local.name_prefix
#
#   # Better practice: private subnets
#   private_subnet_ids = module.network.private_subnet_ids
#   db_sg_id           = module.security_group.db_sg_id
#
#   db_name         = var.db_name
#   master_username = var.db_master_username
#   master_password = var.db_master_password
#
#   # If your rds module exposes engine/instance_class, wire these:
#   # instance_class    = var.db_instance_class
#   # allocated_storage = var.db_allocated_storage
#   # engine_version    = var.db_engine_version
#
#   tags = local.common_tags
# }

# -----------------------------------------------------------------------------
# IAM MODULE (optional) - create task roles for ECS
# If you already provide role ARNs via variables, you can skip this.
# -----------------------------------------------------------------------------
# module "iam" {
#   source      = "../modules/iam"
#   name_prefix = local.name_prefix
#   tags        = local.common_tags
# }

# -----------------------------------------------------------------------------
# ECS FARGATE SERVICE MODULE (instead of aws_ecs_cluster/task_definition/service)
# -----------------------------------------------------------------------------
# module "ecs_fargate_service" {
#   source      = "../modules/ecs-fargate-service"
#   name_prefix = local.name_prefix
#
#   aws_region         = var.aws_region
#   private_subnet_ids = module.network.private_subnet_ids
#   ecs_sg_id          = module.security_group.ecs_sg_id
#
#   container_image = var.container_image
#   container_port  = var.allowed_http_port
#
#   desired_count = var.ecs_desired_count
#   cpu           = var.ecs_task_cpu
#   memory        = var.ecs_task_memory
#
#   # If you use IAM module
#   # task_execution_role_arn = module.iam.task_execution_role_arn
#   # task_role_arn           = module.iam.task_role_arn
#
#   # Or if you keep using existing vars:
#   task_execution_role_arn = var.ecs_execution_role_arn
#   task_role_arn           = var.ecs_task_role_arn
#
#   # If module supports passing environment variables into container:
#   # environment = {
#   #   DB_HOST = module.rds.db_endpoint
#   #   DB_PORT = tostring(module.rds.db_port)
#   #   DB_USER = var.db_master_username
#   #   DB_PASS = var.db_master_password
#   #   DB_NAME = var.db_name
#   # }
#
#   tags = local.common_tags
# }