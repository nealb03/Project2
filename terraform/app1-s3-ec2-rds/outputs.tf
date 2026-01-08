output "backend_public_ip" {
  description = "Backend EC2 Public IP (if enable_ec2 = true)."
  value       = var.enable_ec2 ? aws_instance.backend[0].public_ip : null
}

output "rds_endpoint" {
  description = "RDS Endpoint for the database instance."
  value       = aws_db_instance.cloud495.endpoint
}

output "s3_website_endpoint" {
  description = "Public website URL for the S3 frontend (if enable_s3_website = true)."
  value       = var.enable_s3_website ? aws_s3_bucket_website_configuration.frontend_website[0].website_endpoint : null
}