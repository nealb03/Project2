locals {
  name_suffix = "${var.environment}-${terraform.workspace}"

  backend_sg_name   = "backend-sg-${local.name_suffix}"
  db_client_sg_name = "db-client-sg-${local.name_suffix}"

  use_existing_rds = var.existing_rds_identifier != ""

  # Only used if enable_rds=true (new DB creation)
  create_db_username = (
    var.db_username != "" ? var.db_username :
    var.db_master_username != "" ? var.db_master_username :
    "cloud495"
  )

  create_db_password = (
    var.db_password != "" ? var.db_password :
    var.db_master_password != "" ? var.db_master_password :
    "ChangeMe123!ChangeMe123!"
  )
}

############################
# EXISTING NETWORK (NO CREATE)
############################

data "aws_vpc" "existing" {
  id = var.existing_vpc_id
}

data "aws_subnet" "public_a" {
  id = var.existing_public_subnet_ids[0]
}

data "aws_subnet" "public_b" {
  id = var.existing_public_subnet_ids[1]
}

############################
# EXISTING RDS (READ-ONLY, BY IDENTIFIER ONLY)
############################

data "aws_db_instance" "existing" {
  count                  = local.use_existing_rds ? 1 : 0
  db_instance_identifier = var.existing_rds_identifier
}

############################
# SECURITY GROUPS
############################

resource "aws_security_group" "backend_sg" {
  count       = var.enable_ec2 ? 1 : 0
  name        = local.backend_sg_name
  description = "Security group for backend EC2 instance"
  vpc_id      = data.aws_vpc.existing.id

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
    Name        = local.backend_sg_name
    Environment = var.environment
  }
}

resource "aws_security_group" "db_client_sg" {
  count       = var.enable_ec2 ? 1 : 0
  name        = local.db_client_sg_name
  description = "DB client SG (attach to EC2; allow on existing RDS SG inbound 3306)"
  vpc_id      = data.aws_vpc.existing.id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = local.db_client_sg_name
    Environment = var.environment
  }
}

############################
# BACKEND EC2 INSTANCE (OPTIONAL)
############################

resource "aws_instance" "backend" {
  count = var.enable_ec2 ? 1 : 0

  ami                         = var.windows_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = data.aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name                    = var.ec2_key_name

  vpc_security_group_ids = [
    aws_security_group.backend_sg[0].id,
    aws_security_group.db_client_sg[0].id,
  ]

  user_data = <<-EOF
    $ErrorActionPreference = "Stop"
    $netfxInstaller = "ndp48-x86-x64-allos-enu.exe"
    $netfxUrl = "https://download.microsoft.com/download/9/5/F/95F98B3F-9F50-4EA0-9A19-3B2AEA4BDEDA/ndp48-x86-x64-allos-enu.exe"
    Invoke-WebRequest -Uri $netfxUrl -OutFile "C:\\$netfxInstaller"
    Start-Process -FilePath "C:\\$netfxInstaller" -ArgumentList "/q /norestart" -Wait

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
# FRONTEND S3 STATIC WEBSITE HOSTING (OPTIONAL)
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

  depends_on = [aws_s3_bucket_public_access_block.frontend_pab]

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

############################
# OPTIONAL: CREATE A NEW RDS (ONLY IF enable_rds=true)
############################

resource "aws_db_instance" "cloud495" {
  count = var.enable_rds ? 1 : 0

  identifier        = var.db_instance_identifier
  engine            = "mysql"
  engine_version    = "8.0.40"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = local.create_db_username
  password = local.create_db_password
  db_name  = var.db_name

  publicly_accessible = true
  skip_final_snapshot = true

  vpc_security_group_ids = []
  db_subnet_group_name   = var.existing_db_subnet_group_name

  tags = {
    Name        = var.db_instance_identifier
    Environment = var.environment
  }
}