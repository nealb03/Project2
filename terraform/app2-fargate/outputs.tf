output "ecs_cluster_id" {
  value       = aws_ecs_cluster.cluster.id
  description = "ECS Cluster ID"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "ECS Cluster name"
}

output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "ECS Fargate Service name"
}

output "ecs_service_arn" {
  value       = aws_ecs_service.service.arn
  description = "ECS Fargate Service ARN"
}

output "rds_address" {
  value       = aws_db_instance.db.address
  description = "RDS hostname (no port). Use this for DB_HOST in applications."
}

output "rds_port" {
  value       = aws_db_instance.db.port
  description = "RDS port"
}

output "rds_endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "RDS endpoint in host:port format (useful for CLI tools)"
}

output "rds_db_name" {
  value       = aws_db_instance.db.db_name
  description = "Database name created in RDS"
}