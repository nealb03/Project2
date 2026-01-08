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