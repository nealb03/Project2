output "backend_public_ip" {
  value = module.app_stack.backend_public_ip
}

output "rds_endpoint" {
  value = module.app_stack.rds_endpoint
}

output "s3_website_endpoint" {
  value = module.app_stack.s3_website_endpoint
}