\# AWS Cloud Architecture Projects Portfolio



This repository demonstrates two different AWS cloud architecture patterns for full-stack web applications.



---



\## 📁 Projects



\### \[Project 1: S3 + EC2 + RDS (Traditional Three-Tier)](./Project1-S3-EC2-RDS/)



\*\*Architecture:\*\* Traditional three-tier with managed services



\*\*Components:\*\*

\- \*\*Frontend:\*\* React SPA on S3 Static Website Hosting

\- \*\*Backend:\*\* ASP.NET Core Web API on Windows EC2

\- \*\*Database:\*\* MySQL on Amazon RDS



\*\*Key Features:\*\*

\- Cost-effective for low-to-medium traffic

\- Simple deployment model

\- Direct control over EC2 instance

\- Traditional VM-based architecture



\*\*Tech Stack:\*\* React, Vite, C#, ASP.NET Core, Entity Framework Core, MySQL



\*\*Access:\*\*

\- Frontend: http://nealb03-frontend-bucket-unique-2887.s3-website-us-east-1.amazonaws.com/

\- Backend API: http://34.192.116.54:5001



\[📖 View Project 1 Documentation →](./Project1-S3-EC2-RDS/README.md)



---



\### \[Project 2: ECS Fargate (Containerized Serverless)](./Project2-Fargate/)



\*\*Architecture:\*\* Fully containerized serverless architecture



\*\*Components:\*\*

\- \*\*Frontend:\*\* React container on ECS Fargate

\- \*\*Backend:\*\* API container on ECS Fargate

\- \*\*Database:\*\* Amazon RDS MySQL

\- \*\*Load Balancer:\*\* Application Load Balancer



\*\*Key Features:\*\*

\- Auto-scaling based on demand

\- High availability with multi-AZ deployment

\- Infrastructure as Code (CloudFormation/Terraform)

\- CI/CD with GitHub Actions

\- Container orchestration with ECS



\*\*Tech Stack:\*\* Docker, ECS Fargate, ECR, ALB, RDS



\[📖 View Project 2 Documentation →](./Project2-Fargate/README.md)



---



\## 🔄 Architecture Comparison



| Feature | Project 1 (S3+EC2+RDS) | Project 2 (ECS Fargate) |

|---------|------------------------|-------------------------|

| \*\*Frontend Hosting\*\* | S3 Static Website | ECS Fargate Container |

| \*\*Backend Hosting\*\* | EC2 (Windows Server) | ECS Fargate Container |

| \*\*Backend Language\*\* | C# / ASP.NET Core | Containerized (Any) |

| \*\*Scalability\*\* | Manual (resize EC2) | Automatic (ECS Auto Scaling) |

| \*\*Availability\*\* | Single instance | Multi-AZ with health checks |

| \*\*Cost Model\*\* | Fixed (EC2 always running) | Pay-per-use (scales to zero) |

| \*\*Management Overhead\*\* | Higher (manual updates) | Lower (automated deployments) |

| \*\*Deployment\*\* | Manual/RDP | CI/CD Pipeline |

| \*\*Container Support\*\* | No | Yes (Docker) |

| \*\*Load Balancing\*\* | ALB (optional) | ALB (integrated) |

| \*\*Best For\*\* | Learning, low traffic, cost-conscious | Production, variable traffic, enterprise |



---



\## 🎯 Learning Outcomes



Both projects demonstrate:

\- ✅ Full-stack application development

\- ✅ AWS cloud architecture patterns

\- ✅ Database integration (RDS MySQL)

\- ✅ Security best practices (VPC, Security Groups, IAM)

\- ✅ Infrastructure design considerations



\*\*Project 1\*\* focuses on:

\- Traditional VM-based deployment

\- Manual infrastructure management

\- Windows Server administration

\- Cost optimization for always-on workloads

\- Direct server access and control



\*\*Project 2\*\* focuses on:

\- Modern containerized architectures

\- Serverless compute patterns

\- Automated scaling and deployment

\- DevOps best practices

\- Microservices architecture



---



\## 🚀 Quick Start



\### Project 1 - S3 + EC2 + RDS

```bash

cd Project1-S3-EC2-RDS



\# Frontend

cd Frontend

npm install

npm run build

aws s3 sync dist/ s3://nealb03-frontend-bucket-unique-2887 --delete



\# Backend (on EC2)

cd Backend

dotnet restore

dotnet run --urls "http://0.0.0.0:5001"

