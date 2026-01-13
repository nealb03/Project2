variable "name_prefix"     { type = string }
variable "vpc_id"          { type = string }
variable "container_port"  { type = number default = 80 }
variable "db_port"         { type = number default = 5432 }
variable "tags"            { type = map(string) default = {} }