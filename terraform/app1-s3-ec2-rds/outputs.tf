output "backend_public_ip" {
  description = "Backend EC2 Public IP"
  value       = aws_instance.backend.public_ip
}

output "rds_endpoint" {
  description = "RDS Endpoint for 'cloud495' database"
  value       = aws_db_instance.cloud495.endpoint
}

output "s3_website_endpoint" {
  description = "Public website URL for the S3 frontend"
  value       = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}