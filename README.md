Full DevOps Pipeline on AWS

A complete DevOps project demonstrating how a backend application can be containerized, provisioned on AWS using Terraform, and automated through GitHub Actions and Jenkins across Dev, Staging, and Production environments.

🚀 Project Overview

This project implements an end-to-end DevOps workflow for a Node.js backend application.

The main objective is to demonstrate an enterprise-style setup where:

GitHub Actions handles Continuous Integration (CI)
Jenkins handles deployment and infrastructure operations
Terraform provisions AWS infrastructure
Docker containerizes the application
Amazon ECR stores Docker images
CloudWatch & SNS provide monitoring and notifications
Separate configurations and Terraform state are maintained for Dev, Staging, and Production
🏗️ Architecture
                    Developer
                        │
                        ▼
                   GitHub Repository
                        │
             ┌──────────┴──────────┐
             │                     │
             ▼                     ▼
      GitHub Actions             Jenkins
          (CI)                    (CD)
             │                     │
      ┌──────┴──────┐              │
      │             │              │
 Terraform CI    Docker CI         │
      │             │              │
      │             ▼              │
      │        Amazon ECR ◄────────┘
      │
      ▼
   Terraform
      │
      ▼
┌──────────────────────────────┐
│          AWS Cloud           │
│                              │
│  VPC                         │
│   ├── EC2                    │
│   ├── RDS MySQL              │
│   ├── S3                     │
│   ├── CloudWatch             │
│   └── SNS                    │
└──────────────────────────────┘
🛠️ Technologies Used
Category	Technologies
Cloud	AWS
Infrastructure as Code	Terraform
Containerization	Docker
Container Registry	Amazon ECR
CI	GitHub Actions
CD / Deployment	Jenkins
Application	Node.js, Express, MySQL
Monitoring	CloudWatch, SNS
Version Control	Git, GitHub
OS / Scripting	Linux, Shell
🌍 Environments

The project supports three environments:

Dev
 │
 ▼
Staging
 │
 ▼
Production

Each environment has its own Terraform configuration and remote state.

Terraform state is stored in Amazon S3, with DynamoDB state locking to prevent concurrent state modifications.

🔄 CI/CD Workflow
GitHub Actions — CI

GitHub Actions performs the CI activities when code is pushed to the appropriate branch.

The pipeline includes:

Checkout source code
Terraform formatting validation
Terraform validation
Terraform plan
Docker image build
Docker image push to Amazon ECR

Production Terraform execution is manually triggered and protected through the GitHub production environment approval.

Jenkins — CD

Jenkins is used for deployment and infrastructure operations.

The Jenkins pipeline supports:

Environment selection
Terraform Apply
Terraform Destroy
AWS authentication
ECR integration
Environment-specific configuration
Secure credential handling

This separates CI activities from deployment operations, similar to an enterprise DevOps workflow.

🐳 Docker

The backend application is containerized using Docker.

The Docker image is built and pushed to Amazon ECR with environment-specific image tags.

Example:

dev-<commit>
staging-<commit>
prod-<commit>
☁️ AWS Infrastructure

Terraform provisions the required AWS infrastructure, including:

VPC and networking
EC2
RDS MySQL
IAM
S3
CloudWatch
SNS
EC2 key pair

Terraform modules are used to keep the infrastructure reusable and organized.

📊 Monitoring

AWS CloudWatch is used for application and infrastructure logging.

SNS is configured for alert notifications.

This provides visibility into the deployed environment and allows notifications to be triggered for configured monitoring events.

🔐 Security

Sensitive configuration is intentionally excluded from the repository.

The project uses:

GitHub Secrets
Jenkins Credentials
AWS IAM credentials
.gitignore for sensitive files
Terraform remote state
Environment-specific variables

Passwords, .tfvars, .env, private keys, and Terraform state files are not committed to Git.

📁 Repository Structure
full-devops-pipeline-aws/
│
├── application/
│   └── backend/
│
├── terraform/
│   ├── backend/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── modules/
│       ├── cloudwatch/
│       ├── ec2/
│       ├── iam/
│       └── rds/
│
├── .github/
│   └── workflows/
│       ├── docker-build-push.yml
│       ├── terraform-dev.yml
│       ├── terraform-staging.yml
│       └── terraform-prod.yml
│
├── Dockerfile
├── docker-compose.yml
├── Jenkinsfile
└── README.md
🎯 Project Goals

This project was built to demonstrate practical knowledge of:

Infrastructure as Code
AWS infrastructure provisioning
CI/CD pipeline design
Docker containerization
GitHub Actions
Jenkins
Multi-environment deployments
Terraform remote state management
AWS monitoring
Secure credential management