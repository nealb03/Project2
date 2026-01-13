variable "vpc_id" {
  type = string
  description = "VPC Id"
}

variable "cidr_block" {
  type = string
  default = "Subnet cidr block"
}

variable "webserver_name" {
    type        = string
    description = "Name of the webserver"
}   

variable "ami" {
    type        =   string
    description = "AMI to use on the webserver instance."
}

variable "instance_type" {
    type        =   string
    description = "Instance type"
}
