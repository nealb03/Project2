output "backend_public_ip" {
  description = "EC2 backend public IP"
  value       = module.app_stack.backend_public_ip
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.app_stack.rds_endpoint
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = module.app_stack.s3_website_endpoint
}