output "ecs_cluster_id" {
  value       = aws_ecs_cluster.cluster.id
  description = "ECS Cluster ID"
}

output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "ECS Fargate Service Name"
}

output "rds_endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "App2 RDS Database endpoint"
}