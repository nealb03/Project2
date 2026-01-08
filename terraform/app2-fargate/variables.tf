variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "my_ip_cidr" {
  description = "CIDR for accessing RDS and ECS tasks"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "allowed_http_port" {
  type    = number
  default = 80
}

variable "db_identifier" {
  type    = string
  default = "app2-db"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_master_username" {
  type = string
}

variable "db_master_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "app2db"
}

variable "ecs_task_family" {
  type    = string
  default = "app2-fargate-task"
}

variable "ecs_task_cpu" {
  type    = string
  default = "256"
}

variable "ecs_task_memory" {
  type    = string
  default = "512"
}

variable "ecs_execution_role_arn" {
  type = string
  description = "ARN of ECS task execution role"
}

variable "ecs_task_role_arn" {
  type = string
  description = "ARN of ECS task role"
}

variable "container_image" {
  type = string
  description = "Container image for the ECS task (e.g., AWS ECR or Docker Hub image)"
}

variable "ecs_desired_count" {
  type    = number
  default = 1
}