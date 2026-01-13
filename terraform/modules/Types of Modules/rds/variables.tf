variable "name_prefix"        { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "db_sg_id"           { type = string }

variable "db_name"            { type = string default = "appdb" }
variable "master_username"    { type = string }
variable "master_password"    { type = string sensitive = true }

variable "instance_class"     { type = string default = "db.t3.micro" }
variable "allocated_storage"  { type = number default = 20 }
variable "engine_version"     { type = string default = "15.5" }

variable "tags"               { type = map(string) default = {} }