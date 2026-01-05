## Terraform Apps & GitHub Actions Workflows:

This folder contains multiple Terraform “apps” and two reusable GitHub Actions workflows:

- **Terraform App (Demo)** – safe, read‑only `plan` for interviews/demos
- **Terraform Deploy (Plan + Apply – Multi‑App, Real Changes)** – full deploy workflow that can plan and apply for any app under `terraform/`

---

### 📁 Apps

Each subfolder under `terraform/` is a Terraform root module:

- `app1-s3-ec2-rds` – simulates an S3/EC2/RDS-style three‑tier stack
- `app2-fargate` – simulates a Fargate/ECS-based app
- `demo3` (optional/future) – placeholder for additional examples

The workflows are **app‑agnostic**: they take the app name as an input and set:

```bash
TF_WORKDIR=terraform/${{ github.event.inputs.app }}

1. Terraform App (Demo) – Safe, Read‑Only Plan
This repository includes a reusable Terraform demo workflow that runs a safe, read‑only terraform plan for multiple apps without requiring AWS credentials.

Workflow file: .github/workflows/terraform-app.yml
Workflow name: Terraform App (Demo)

How the demo workflow works
Inputs (GitHub Actions workflow_dispatch):

app: selects the Terraform app folder under terraform/
e.g. app1-s3-ec2-rds, app2-fargate

environment: logical environment name (e.g. demo, dev, prod)

aws_region: kept as a parameter for future extension (e.g. us-east-1)


Job steps:

Checkout repo

Show selected app, environment, and aws_region

Set TF_WORKDIR=terraform/${{ github.event.inputs.app }}

Run terraform init (local backend)

Run terraform validate

Run terraform plan (NO APPLY – demo only)


Safety

No aws provider and no data "aws_*" in these demo root modules

Plan only; no terraform apply in this workflow

Designed to be safe to run in job interviews and demos without touching real AWS resources


2. Terraform Deploy (Plan + Apply – Multi‑App, Real Changes)
In addition to the demo workflow, there is a real deployment workflow that can perform terraform apply and make actual changes when configured against real infrastructure.

Workflow file: .github/workflows/terraform-deploy.yml
Workflow name: Terraform Deploy (Plan + Apply - Multi-App, Real Changes)

Key characteristics
Reusable multi‑app design:

Takes an app input and uses TF_WORKDIR=terraform/${app}

The same workflow can deploy:
app1-s3-ec2-rds

app2-fargate

any future app under terraform/


You can trigger multiple runs in parallel, each targeting a different app folder


Inputs:

app – Terraform app folder under terraform/

environment – logical environment (e.g. dev, prod)

aws_region – AWS region (e.g. us-east-1)

confirm_apply – must be set to "APPLY" to allow real changes


Deploy workflow steps
Checkout repository

Echo selected app, environment, aws_region, and confirm_apply

Setup Terraform (pinned version)

terraform init in terraform/${app}

terraform validate

terraform plan -compact-warnings

Conditional terraform apply -auto-approve if:
github.event.inputs.confirm_apply == 'APPLY'

