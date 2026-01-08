provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Route Table for Public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Backend Security Group (for EC2 or other backend services)
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "SG for backend EC2 or app services"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = var.allowed_http_port
    to_port     = var.allowed_http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP inbound"
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.allowed_rdp_cidr]
    description = "Allow RDP inbound"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "backend-sg"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "SG for RDS access"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.rds_access_cidr]
    description = "Allow MySQL access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "rds-sg"
  }
}

# RDS subnet group for public subnets
resource "aws_db_subnet_group" "cloud495_db_subnet_group_public" {
  count      = var.manage_rds ? 1 : 0
  name       = "${var.db_identifier}-db-subnet-group-public"
  subnet_ids = aws_subnet.public.*.id

  tags = {
    Name = "${var.db_identifier}-db-subnet-group-public"
  }
}

# RDS Instance
resource "aws_db_instance" "cloud495" {
  count                  = var.manage_rds ? 1 : 0
  identifier             = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_master_username
  password               = var.db_master_password
  db_name                = var.db_name
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.cloud495_db_subnet_group_public[0].name
  multi_az               = false

  tags = {
    Name = var.db_identifier
  }
}

# Conditional EC2 instance (only if enable_ec2)
resource "aws_instance" "backend" {
  count                     = var.enable_ec2 ? 1 : 0
  ami                       = data.aws_ami.windows_server.id
  instance_type             = var.instance_type
  subnet_id                 = var.subnet_id_for_ec2
  vpc_security_group_ids    = [aws_security_group.backend_sg.id]
  associate_public_ip_address = var.associate_public_ip
  key_name                  = var.key_name
  user_data                 = var.user_data_script

  tags = {
    Name = "windows-backend"
  }
}

# AMI data source for EC2 Windows Server (only needed if EC2 enabled)
data "aws_ami" "windows_server" {
  count      = var.enable_ec2 ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }
}

# Conditional S3 bucket and website hosting (only if enable_s3_website=true and bucket name provided)
resource "aws_s3_bucket" "frontend_bucket" {
  count = var.enable_s3_website && length(var.s3_bucket_name) > 0 ? 1 : 0

  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name = "frontend-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_pab" {
  count  = var.enable_s3_website && length(var.s3_bucket_name) > 0 ? 1 : 0
  bucket = aws_s3_bucket.frontend_bucket[0].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  count  = var.enable_s3_website && length(var.s3_bucket_name) > 0 ? 1 : 0
  bucket = aws_s3_bucket.frontend_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.frontend_bucket[0].arn}/*"
    }]
  })
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  count  = var.enable_s3_website && length(var.s3_bucket_name) > 0 ? 1 : 0
  bucket = aws_s3_bucket.frontend_bucket[0].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}