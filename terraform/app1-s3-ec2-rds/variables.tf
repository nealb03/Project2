variable "aws_region" {
  description = "AWS Region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "my_ip_cidr" {
  description = "Your public IP with CIDR suffix for RDP access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "key_name" {
  description = "SSH/RDP key pair name for EC2 instance"
  type        = string
  default     = "keypair-vpc1"
}

variable "user_data_script" {
  description = "User data script for the Windows backend EC2 instance"
  type        = string
  default     = <<-EOF
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
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for frontend static website"
  type        = string
  default     = "nealb03-frontend-bucket-unique-2887"
}