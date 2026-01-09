\# app1-s3-ec2-rds (Terraform Demo)



This folder contains a small Terraform stack used for a job demonstration. It provisions an AWS S3 static website bucket and a Windows EC2 instance inside an \*\*existing\*\* VPC/subnets. It can optionally reference an existing RDS instance \*\*read-only\*\* (by DB identifier), but this stack does \*\*not\*\* manage or modify the existing database.



\## What this stack creates



When enabled via `terraform.tfvars`, this stack can create:



\- An S3 bucket configured for \*\*static website hosting\*\*

\- A Windows EC2 instance (backend host)

\- Two Security Groups:

&nbsp; - `backend\_sg`: allows HTTP (80) from anywhere and RDP (3389) from `my\_ip\_cidr`

&nbsp; - `db\_client\_sg`: attached to EC2 so it can be allowed into an existing RDS SG inbound rule (MySQL 3306)



\## What this stack does NOT create.



\- No VPC, subnets, route tables, IGWs, NATs, etc. (it uses existing network IDs you provide)

\- No RDS instance unless you explicitly set `enable\_rds = true`

\- No automatic modification of an existing RDS Security Group (you must add the inbound rule manually)



\## Files



\- `providers.tf` – provider configuration

\- `variables.tf` – input variables

\- `terraform.tfvars` – environment values for this demo

\- `main.tf` – resources and data sources

\- `outputs.tf` – output values (EC2 IP, S3 website endpoint, etc.)

\- `terraform.tfstate\*` – local state files (demo only; do not commit to shared repos)



\## Prerequisites



\- Terraform installed

\- AWS credentials available (AWS CLI configured or environment variables)

\- Existing AWS resources available:

&nbsp; - VPC ID

&nbsp; - Two public subnet IDs

&nbsp; - EC2 key pair for RDP

&nbsp; - (Optional) Existing DB subnet group name, only if creating RDS



\## Quick start (local)



From this folder:



```powershell

terraform init

terraform fmt -recursive

terraform validate

terraform plan

terraform apply


To tear down resources created by this stack:

terraform destroy


