locals {
  # Convert empty strings to null so coalesce() can skip them
  db_username_candidate        = var.db_username != "" ? var.db_username : null
  db_master_username_candidate = var.db_master_username != "" ? var.db_master_username : null

  db_password_candidate        = var.db_password != "" ? var.db_password : null
  db_master_password_candidate = var.db_master_password != "" ? var.db_master_password : null

  effective_db_username = coalesce(
    local.db_username_candidate,
    local.db_master_username_candidate,
    "cloud-495",
  )

  effective_db_password = coalesce(
    local.db_password_candidate,
    local.db_master_password_candidate,
    "password",
  )
}

############################
# VPC + NETWORKING
############################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "main-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "main-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az_a

  tags = {
    Name        = "public-subnet-a"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az_b

  tags = {
    Name        = "public-subnet-b"
    Environment = var.environment
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "public-rt"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

############################
# SECURITY GROUPS
############################

resource "aws_security_group" "backend_sg" {
  count       = var.enable_ec2 ? 1 : 0
  name        = "backend-sg"
  description = "Security group for backend EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow RDP from my IP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "backend-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow MySQL access from anywhere (restrict for production)"
    from_port   = 3306
    to_port     = 3306
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

  tags = {
    Name        = "rds-sg"
    Environment = var.environment
  }
}

############################
# RDS DATABASE IN PUBLIC SUBNETS
############################

resource "aws_db_subnet_group" "cloud495_db_subnet_group_public" {
  name       = "cloud495-db-subnet-group-public"
  subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

  tags = {
    Name        = "cloud495-db-subnet-group-public"
    Environment = var.environment
  }
}

resource "aws_db_instance" "cloud495" {
  identifier        = var.db_instance_identifier
  engine            = "mysql"
  engine_version    = "8.0.40"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = local.effective_db_username
  password = local.effective_db_password
  db_name  = var.db_name

  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.cloud495_db_subnet_group_public.name
  multi_az               = false

  tags = {
    Name        = "cloud495"
    Environment = var.environment
  }
}

############################
# BACKEND EC2 INSTANCE (NO DescribeImages)
############################

resource "aws_instance" "backend" {
  count = var.enable_ec2 ? 1 : 0

  ami                         = var.windows_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.backend_sg[0].id]
  associate_public_ip_address = true
  key_name                    = var.ec2_key_name

  user_data = <<-EOF
    $ErrorActionPreference = "Stop"
    # Install .NET Framework 4.8
    $netfxInstaller = "ndp48-x86-x64-allos-enu.exe"
    $netfxUrl = "https://download.microsoft.com/download/9/5/F/95F98B3F-9F50-4EA0-9A19-3B2AEA4BDEDA/ndp48-x86-x64-allos-enu.exe"
    Invoke-WebRequest -Uri $netfxUrl -OutFile "C:\\$netfxInstaller"
    Start-Process -FilePath "C:\\$netfxInstaller" -ArgumentList "/q /norestart" -Wait

    # Install Visual Studio Build Tools 2019
    $vsInstallerUrl = "https://aka.ms/vs/16/release/vs_buildtools.exe"
    $vsInstallerPath = "C:\\vs_buildtools.exe"
    Invoke-WebRequest -Uri $vsInstallerUrl -OutFile $vsInstallerPath
    Start-Process -FilePath $vsInstallerPath -ArgumentList "--quiet --wait --norestart --nocache --installPath C:\\BuildTools --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools" -Wait

    New-NetFirewallRule -DisplayName "HTTP" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
  EOF

  tags = {
    Name        = "windows-backend"
    Environment = var.environment
  }
}

############################
# FRONTEND S3 STATIC WEBSITE HOSTING
############################

resource "aws_s3_bucket" "frontend_bucket" {
  count         = var.enable_s3_website ? 1 : 0
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name        = "frontend-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_pab" {
  count                   = var.enable_s3_website ? 1 : 0
  bucket                  = aws_s3_bucket.frontend_bucket[0].id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  count  = var.enable_s3_website ? 1 : 0
  bucket = aws_s3_bucket.frontend_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket[0].arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  count  = var.enable_s3_website ? 1 : 0
  bucket = aws_s3_bucket.frontend_bucket[0].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}