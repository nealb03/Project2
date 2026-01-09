# NOTE:
# app2-fargate/main.tf currently contains demo scaffolding only (no active resources/modules).
# Outputs avoid referencing aws_* resources or module.* outputs so that `terraform validate` passes.

output "aws_region" {
  description = "AWS region used for this deployment"
  value       = var.aws_region
}

output "my_ip_cidr" {
  description = "Client IP CIDR used for inbound rules (demo)"
  value       = var.my_ip_cidr
}

output "vpc_cidr" {
  description = "VPC CIDR configuration"
  value       = var.vpc_cidr
}

output "public_subnet_cidrs" {
  description = "Public subnet CIDRs configuration"
  value       = var.public_subnet_cidrs
}

output "availability_zones" {
  description = "Availability zones configuration"
  value       = var.availability_zones
}

output "allowed_http_port" {
  description = "Inbound HTTP port exposed by the container/service"
  value       = var.allowed_http_port
}

output "db_identifier" {
  description = "RDS identifier configuration"
  value       = var.db_identifier
}

output "db_engine" {
  description = "RDS engine configuration"
  value       = var.db_engine
}

output "db_engine_version" {
  description = "RDS engine version configuration"
  value       = var.db_engine_version
}

output "db_instance_class" {
  description = "RDS instance class configuration"
  value       = var.db_instance_class
}

output "db_allocated_storage" {
  description = "RDS allocated storage configuration (GB)"
  value       = var.db_allocated_storage
}

output "db_name" {
  description = "Initial DB name configuration"
  value       = var.db_name
}

output "ecs_task_family" {
  description = "ECS task family name configuration"
  value       = var.ecs_task_family
}

output "ecs_task_cpu" {
  description = "Fargate task CPU units configuration"
  value       = var.ecs_task_cpu
}

output "ecs_task_memory" {
  description = "Fargate task memory (MiB) configuration"
  value       = var.ecs_task_memory
}

output "container_image" {
  description = "Container image configured for the ECS task"
  value       = var.container_image
}

output "ecs_desired_count" {
  description = "Desired ECS task count"
  value       = var.ecs_desired_count
}