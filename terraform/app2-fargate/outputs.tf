output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.app2_cluster.id
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.app2_service.name
}

output "fargate_load_balancer_dns" {
  description = "Public DNS of Fargate Application Load Balancer"
  value       = aws_lb.app2_alb.dns_name
}

output "vpc_id" {
  description = "VPC ID from module"
  value       = module.app_stack.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs from module"
  value       = module.app_stack.public_subnet_ids
}