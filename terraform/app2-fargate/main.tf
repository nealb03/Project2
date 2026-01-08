terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "my_ip_cidr" {
  description = "Your IP CIDR for allowed RDP (can remain for security group setting)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_endpoint" {
  description = "RDS database endpoint shared from app1"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "container_image" {
  description = "Docker container image URI for the Fargate task"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

##############################
# Network and RDS module call
##############################
module "app_stack" {
  source              = "../terraform/modules/app_stack"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]

  allowed_http_port = var.container_port
  allowed_rdp_cidr   = var.my_ip_cidr
  rds_access_cidr   = "0.0.0.0/0"

  manage_rds        = false
}

##############################
# ECS Cluster
##############################
resource "aws_ecs_cluster" "app2_cluster" {
  name = "app2-fargate-cluster"
}

##############################
# IAM Role for ECS Task Execution
##############################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "app2-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

##############################
# ECS Task Definition
##############################
resource "aws_ecs_task_definition" "app2_task" {
  family                   = "app2-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app2-container"
      image     = var.container_image
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "DB_ENDPOINT", value = var.db_endpoint },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "DB_PASSWORD", value = var.db_password }
      ]
    }
  ])
}

##############################
# Security Group for ALB
##############################
resource "aws_security_group" "alb_sg" {
  name        = "app2-alb-sg"
  description = "Allow inbound HTTP to ALB"
  vpc_id      = module.app_stack.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############################
# Application Load Balancer
##############################
resource "aws_lb" "app2_alb" {
  name               = "app2-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.app_stack.public_subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "app2_tg" {
  name     = "app2-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = module.app_stack.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app2_listener" {
  load_balancer_arn = aws_lb.app2_alb.arn
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app2_tg.arn
  }
}

##############################
# ECS Service with ALB integration
##############################
resource "aws_ecs_service" "app2_service" {
  name            = "app2-fargate-service"
  cluster         = aws_ecs_cluster.app2_cluster.id
  task_definition = aws_ecs_task_definition.app2_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.app_stack.public_subnet_ids
    security_groups = [module.app_stack.backend_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app2_tg.arn
    container_name   = "app2-container"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.app2_listener]
}