# Limit DB access to your public IP (recommended for demo)
my_ip_cidr = "203.0.113.25/32"

# RDS credentials (DEMO PROD ONLY)
db_master_username = "admin"
db_master_password = "password"

# ECS roles (can be created by Terraform later if you want)
ecs_execution_role_arn = "arn:aws:iam::123456789012:role/ecsExecutionRole"
ecs_task_role_arn      = "arn:aws:iam::123456789012:role/ecsTaskRole"

# Container image used by the ECS task definition
# If you use ECR, this should be like:
# 123456789012.dkr.ecr.us-east-1.amazonaws.com/app2-backend:latest
container_image = "yourdockerhubusername/yourapp2image:latest"