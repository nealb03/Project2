output "backend_public_ip" {
  description = "Public IP address of backend EC2 instance"
  value       = module.app_stack.backend_public_ip
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.app_stack.rds_endpoint
}

output "s3_website_endpoint" {
  description = "S3 website endpoint URL"
  value       = module.app_stack.s3_website_endpoint
}