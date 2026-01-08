aws_region           = "us-east-1"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

allowed_http_port    = 80
allowed_rdp_cidr     = "203.0.113.25/32"
rds_access_cidr      = "10.0.0.0/16"

db_master_username   = "admin"
db_master_password   = "password"
db_identifier        = "cloud495"
db_engine            = "mysql"
db_engine_version    = "8.0.40"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "cloud495"
manage_rds           = true

enable_ec2           = true
instance_type        = "t3.medium"
subnet_id_for_ec2    = "subnet-xxxxxxxx"  # Replace with your real subnet id
associate_public_ip  = true
key_name             = "keypair-vpc1"
user_data_script     = ""

ami_filter_name      = "Windows_Server-*-English-*-Core-Base*"

enable_s3_website    = true
s3_bucket_name       = "nealb03-frontend-bucket-unique-2887"