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

############################
# Cross-variable validation (safe place)
############################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "fargate-vpc" }

  lifecycle {
    precondition {
      condition     = length(var.availability_zones) == length(var.public_subnet_cidrs)
      error_message = "availability_zones and public_subnet_cidrs must be the same length (one subnet per AZ)."
    }
  }
}

############################
# Networking
############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "fargate-igw" }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = { Name = "public-subnet-${count.index + 1}" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-route-table" }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub_subnet_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

############################
# Security Group for ECS Tasks
############################

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-tasks-sg"
  description = "Allow HTTP inbound to Fargate tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.allowed_http_port
    to_port     = var.allowed_http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ecs-tasks-sg" }
}

############################
# RDS Security Group (DEMO: Internet-accessible, locked to your IP)
############################

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "SG for RDS (demo internet access)"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "rds-sg" }
}

############################
# RDS Subnet Group (public subnets for demo reachability)
############################

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = aws_subnet.public[*].id
  tags       = { Name = "${var.db_identifier}-subnet-group" }
}

############################
# RDS Instance (public for demo)
############################

resource "aws_db_instance" "db" {
  identifier        = var.db_identifier
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  username          = var.db_master_username
  password          = var.db_master_password
  db_name           = var.db_name

  publicly_accessible = true
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  multi_az               = false

  tags = { Name = var.db_identifier }
}

############################
# ECS Cluster
############################

resource "aws_ecs_cluster" "cluster" {
  name = "fargate-cluster"
}

############################
# ECS Task Definition
############################

resource "aws_ecs_task_definition" "task" {
  family = var.ecs_task_family

  # ECS API expects strings; variables are numbers -> convert safely.
  cpu    = tostring(var.ecs_task_cpu)
  memory = tostring(var.ecs_task_memory)

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name  = "app2-container"
      image = var.container_image

      portMappings = [
        {
          containerPort = var.allowed_http_port
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "DB_HOST", value = aws_db_instance.db.address },
        { name = "DB_PORT", value = tostring(aws_db_instance.db.port) },
        { name = "DB_USER", value = var.db_master_username },
        { name = "DB_PASS", value = var.db_master_password },
        { name = "DB_NAME", value = var.db_name }
      ]
    }
  ])
}

############################
# ECS Service
############################

resource "aws_ecs_service" "service" {
  name            = "fargate-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.ecs_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_db_instance.db]
}