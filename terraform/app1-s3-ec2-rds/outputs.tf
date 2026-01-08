output "backend_public_ip" {
  description = "Backend EC2 Public IP"
  value       = module.app_stack.backend_instance_public_ip
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.app_stack.db_endpoint
}

output "s3_website_endpoint" {
  description = "Frontend S3 Website URL"
  value       = module.app_stack.frontend_s3_website_endpoint
}