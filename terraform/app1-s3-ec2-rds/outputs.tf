output "backend_public_ip" {
  description = "Backend EC2 public IP (if enable_ec2 = true)."
  value       = var.enable_ec2 ? aws_instance.backend[0].public_ip : null
}

output "db_client_sg_id" {
  description = "SG attached to EC2 for DB access. Add this SG as inbound source (3306) on the existing RDS SG."
  value       = var.enable_ec2 ? aws_security_group.db_client_sg[0].id : null
}

output "existing_rds_identifier" {
  description = "Existing RDS identifier used for lookup (if provided)."
  value       = var.existing_rds_identifier != "" ? var.existing_rds_identifier : null
}

output "existing_rds_endpoint" {
  description = "Existing RDS endpoint (if existing_rds_identifier is set and found)."
  value       = var.existing_rds_identifier != "" ? try(data.aws_db_instance.existing[0].endpoint, null) : null
}

output "existing_rds_address" {
  description = "Existing RDS hostname/address (if existing_rds_identifier is set and found)."
  value       = var.existing_rds_identifier != "" ? try(data.aws_db_instance.existing[0].address, null) : null
}

output "rds_endpoint" {
  description = "New RDS endpoint (only if enable_rds = true)."
  value       = var.enable_rds ? aws_db_instance.cloud495[0].endpoint : null
}

output "rds_address" {
  description = "New RDS hostname/address (only if enable_rds = true)."
  value       = var.enable_rds ? aws_db_instance.cloud495[0].address : null
}

output "s3_website_endpoint" {
  description = "S3 static website endpoint (if enable_s3_website = true)."
  value       = var.enable_s3_website ? aws_s3_bucket_website_configuration.frontend_website[0].website_endpoint : null
}

output "s3_bucket_name" {
  description = "Frontend S3 bucket name (if enable_s3_website = true)."
  value       = var.enable_s3_website ? aws_s3_bucket.frontend_bucket[0].bucket : null
}