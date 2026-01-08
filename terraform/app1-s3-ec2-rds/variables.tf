variable "enable_ec2" {
  type        = bool
  description = "Enable or disable deployment of EC2 instance"
  default     = true
}

variable "enable_s3_website" {
  type        = bool
  description = "Enable or disable deployment of S3 static website"
  default     = true
}

variable "my_ip_cidr" {
  type        = string
  description = "Your public IP with CIDR suffix for RDP access"
  default     = "0.0.0.0/0"
}

variable "db_identifier" {
  type        = string
  description = "RDS database identifier"
  default     = "cloud495"
}

variable "db_master_username" {
  type        = string
  description = "RDS master username"
  default     = "admin"
}

variable "db_master_password" {
  type        = string
  description = "RDS master password"
  default     = "password"
  sensitive   = true
}

variable "public_subnet_a_cidr" {
  type        = string
  description = "CIDR block for public subnet A"
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type        = string
  description = "CIDR block for public subnet B"
  default     = "10.0.2.0/24"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "key_name" {
  type        = string
  description = "Key pair name for EC2 instance"
  default     = "keypair-vpc1"
}

variable "ami_filter_name" {
  type        = string
  description = "AMI filter pattern for Windows Server 2019"
  default     = "Windows_Server-2019-English-Full-Base-*"
}

variable "associate_public_ip" {
  type        = bool
  description = "Whether to assign a public IP to the EC2 instance"
  default     = true
}

variable "user_data_script" {
  type        = string
  description = "User data script for EC2 instance initialization"
  default     = <<-EOD
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
  EOD
}