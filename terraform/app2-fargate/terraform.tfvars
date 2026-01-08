# Demo Environment Configuration for app2-fargate

environment          = "demo"
aws_region           = "us-east-1"

enable_versioning    = true
enable_encryption    = true

# Disable EC2 and S3 resources explicitly for this Fargate app
enable_ec2           = false
enable_s3_website    = false

# RDS connection variables (if RDS is used, set endpoint & credentials accordingly)
db_endpoint          = "your-rds-endpoint"       # e.g., from app1 outputs or manually set
db_username          = "admin"                   # Override with your DB username
db_password          = "password"        # Place secrets securely; do NOT commit plaintext passwords