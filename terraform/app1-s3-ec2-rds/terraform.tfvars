aws_region  = "us-east-1"
environment = "sandbox"

my_ip_cidr = "203.0.113.25/32"

enable_ec2        = true
enable_s3_website = true

windows_ami_id    = "ami-0f6d3d1de3c02ee19"
ec2_key_name      = "keypair-vpc1"
ec2_instance_type = "t3.medium"

db_instance_identifier = "cloud495"
db_name                = "cloud495"

db_master_username = "cloud-495"
db_master_password = "password"

s3_bucket_name = "nealb03-frontend-bucket-unique-2887"

az_a = "us-east-1a"
az_b = "us-east-1b"