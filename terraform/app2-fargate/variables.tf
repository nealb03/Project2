variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR notation (x.x.x.x/32). Used to allow inbound access to the demo RDS instance."
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "my_ip_cidr must be a valid CIDR block (example: 203.0.113.25/32)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the demo VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block (example: 10.0.0.0/16)."
  }
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks. One per availability zone."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 1
    error_message = "public_subnet_cidrs must contain at least one subnet CIDR."
  }
}

variable "availability_zones" {
  description = "List of availability zones used to create subnets. Must match the number of public_subnet_cidrs."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) == length(var.public_subnet_cidrs)
    error_message = "availability_zones must be the same length as public_subnet_cidrs."
  }
}

variable "allowed_http_port" {
  description = "Inbound HTTP port exposed by the container/service"
  type        = number
  default     = 80

  validation {
    condition     = var.allowed_http_port > 0 && var.allowed_http_port <= 65535
    error_message = "allowed_http_port must be a valid TCP port (1-65535)."
  }
}

############################
# RDS (DEMO)
############################

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "app2-db"
}

variable "db_engine" {
  description = "RDS engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.db_allocated_storage >= 20
    error_message = "db_allocated_storage should be at least 20GB for a typical MySQL demo."
  }
}

variable "db_master_username" {
  description = "Master username for the RDS instance (demo)"
  type        = string

  validation {
    condition     = length(var.db_master_username) >= 1
    error_message = "db_master_username must not be empty."
  }
}

variable "db_master_password" {
  description = "Master password for the RDS instance (demo). Do not use a real password in demo code."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_master_password) >= 8
    error_message = "db_master_password must be at least 8 characters."
  }
}

variable "db_name" {
  description = "Initial database name to create"
  type        = string
  default     = "app2db"
}

############################
# ECS / Fargate
############################

variable "ecs_task_family" {
  description = "ECS task definition family name"
  type        = string
  default     = "app2-fargate-task"
}

variable "ecs_task_cpu" {
  description = "Fargate task CPU units (valid examples: 256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.ecs_task_cpu)
    error_message = "ecs_task_cpu must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "ecs_task_memory" {
  description = "Fargate task memory (MiB). Must be compatible with ecs_task_cpu."
  type        = number
  default     = 512

  validation {
    condition     = var.ecs_task_memory >= 512
    error_message = "ecs_task_memory must be at least 512 MiB."
  }
}

variable "ecs_execution_role_arn" {
  description = "ARN of the ECS task execution role (used by ECS agent to pull images, write logs, etc.)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.ecs_execution_role_arn))
    error_message = "ecs_execution_role_arn must look like an IAM role ARN (arn:aws:iam::123456789012:role/RoleName)."
  }
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role (used by your application code at runtime)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.ecs_task_role_arn))
    error_message = "ecs_task_role_arn must look like an IAM role ARN (arn:aws:iam::123456789012:role/RoleName)."
  }
}

variable "container_image" {
  description = "Container image for the ECS task (ECR or Docker Hub image)"
  type        = string

  validation {
    condition     = length(var.container_image) >= 1
    error_message = "container_image must not be empty."
  }
}

variable "ecs_desired_count" {
  description = "Number of desired tasks to run"
  type        = number
  default     = 1

  validation {
    condition     = var.ecs_desired_count >= 0
    error_message = "ecs_desired_count must be 0 or greater."
  }
}