output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public.*.id
}

output "backend_sg_id" {
  description = "Backend EC2 security group ID"
  value       = aws_security_group.backend_sg.id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = var.manage_rds ? (aws_db_instance.cloud495.endpoint) : ""
  sensitive   = false
}

output "backend_instance_public_ip" {
  description = "Public IP of EC2 instance if created"
  value       = var.enable_ec2 ? aws_instance.backend.public_ip : ""
}

output "frontend_s3_website_endpoint" {
  description = "Static Website URL from S3 bucket if enabled"
  value       = (var.enable_s3_website && length(var.s3_bucket_name) > 0) ? aws_s3_bucket_website_configuration.frontend_website[0].website_endpoint : ""
}