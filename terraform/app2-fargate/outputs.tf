output "aws_region" {
  description = "AWS region used for this deployment"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.service.name
}

output "ecs_service_id" {
  description = "ECS service ID (provider-supported identifier)"
  value       = aws_ecs_service.service.id
}

output "ecs_task_definition_arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.task.arn
}

output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.db.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.db.port
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.db.id
}