variable "my_ip_cidr" {
  description = "Your public IP with CIDR suffix for RDP access"
  type        = string
  default     = "0.0.0.0/0"
}