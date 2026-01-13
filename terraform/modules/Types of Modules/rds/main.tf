locals {
  tags = merge(var.tags, {
    Module = "rds"
    Name   = "${var.name_prefix}-db"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = local.tags
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-db"
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.master_username
  password               = var.master_password

  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false
  multi_az               = false

  tags = local.tags
}