variable "my_ip_cidr" {
  description = "Your public IP with CIDR suffix for RDP access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_ec2" {
  description = "Enable EC2 instance deployment"
  type        = bool
  default     = true
}

variable "enable_s3_website" {
  description = "Enable S3 static website deployment"
  type        = bool
  default     = true
}

variable "db_identifier" {
  description = "RDS database identifier"
  type        = string
  default     = "cloud495"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "keypair-vpc1"
}

variable "ami_filter_name" {
  description = "AMI filter pattern for Windows Server"
  type        = string
  default     = "Windows_Server-2019-English-Full-Base-*"
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP with the EC2 instance"
  type        = bool
  default     = true
}

variable "user_data_script" {
  description = "User data script for EC2 instance initialization"
  type        = string
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