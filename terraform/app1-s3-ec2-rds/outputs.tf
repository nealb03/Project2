output "backend_public_ip" {
  description = "Backend EC2 public IP (if enable_ec2 = true)."
  value       = var.enable_ec2 ? aws_instance.backend[0].public_ip : null
}

output "rds_endpoint" {
  description = "RDS endpoint."
  value       = aws_db_instance.cloud495.endpoint
}

output "rds_address" {
  description = "RDS hostname/address."
  value       = aws_db_instance.cloud495.address
}

output "s3_website_endpoint" {
  description = "S3 static website endpoint (if enable_s3_website = true)."
  value       = var.enable_s3_website ? aws_s3_bucket_website_configuration.frontend_website[0].website_endpoint : null
}

output "s3_bucket_name" {
  description = "Frontend S3 bucket name (if enable_s3_website = true)."
  value       = var.enable_s3_website ? aws_s3_bucket.frontend_bucket[0].bucket : null
}