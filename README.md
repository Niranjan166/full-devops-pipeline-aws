# Full DevOps Pipeline on AWS

A complete DevOps project demonstrating an end-to-end workflow for a Node.js backend application using **AWS, Terraform, Docker, GitHub Actions, Jenkins, Amazon ECR, Amazon EKS, Kubernetes, Prometheus, Grafana, and HPA** across Dev, Staging, and Production environments.

---

## 🚀 Project Overview

This project implements an enterprise-style DevOps workflow covering:

* **GitHub Actions** — Continuous Integration (CI)
* **Jenkins** — Deployment and infrastructure operations
* **Terraform** — Infrastructure as Code (IaC)
* **Docker** — Application containerization
* **Amazon ECR** — Container image registry
* **Amazon EKS** — Managed Kubernetes
* **Kubernetes** — Container orchestration
* **Prometheus** — Metrics collection
* **Grafana** — Monitoring and visualization
* **Horizontal Pod Autoscaler (HPA)** — Kubernetes autoscaling
* **CloudWatch & SNS** — AWS monitoring and notifications
* **Amazon RDS MySQL** — Application database

Separate Terraform configurations and remote state are maintained for **Dev, Staging, and Production** environments.

---

# 🏗️ Architecture

## Phase 1 — AWS + Docker + CI/CD

```text
                         Developer
                             │
                             ▼
                      GitHub Repository
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
         GitHub Actions                Jenkins
              (CI)                       (CD)
                │                         │
        ┌───────┴───────┐                 │
        │               │                 │
   Terraform CI     Docker CI             │
        │               │                 │
        │               ▼                 │
        │          Amazon ECR ◄───────────┘
        │
        ▼
     Terraform
        │
        ▼
   AWS Infrastructure
        │
   ┌────┴────────────────────────────┐
   │                                 │
   ▼                                 ▼
  EC2                              RDS MySQL
   │
   ├── CloudWatch
   └── SNS
```

## Phase 2 — Kubernetes & Amazon EKS

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Build
    ├── Test / Validation
    ├── Docker Build
    └── Push Image
            │
            ▼
        Amazon ECR
            │
            ▼
        Amazon EKS
            │
      ┌─────┴──────────┐
      │                │
      ▼                ▼
 Kubernetes        Kubernetes
 Deployment         Service
      │
      ▼
 Backend Pods
      │
      ├── Metrics Server
      │
      └── HPA
            │
            ▼
      1 → 3 Replicas
            │
            ▼
       Prometheus
            │
            ▼
         Grafana
            │
            ▼
       Monitoring
            │
            ▼
        AWS RDS
```

---

# 🛠️ Technologies Used

| Category                | Technologies                    |
| ----------------------- | ------------------------------- |
| Cloud                   | AWS                             |
| Infrastructure as Code  | Terraform                       |
| Containerization        | Docker                          |
| Container Registry      | Amazon ECR                      |
| CI                      | GitHub Actions                  |
| CD / Deployment         | Jenkins                         |
| Container Orchestration | Kubernetes                      |
| Managed Kubernetes      | Amazon EKS                      |
| Application             | Node.js, Express, MySQL         |
| Database                | Amazon RDS MySQL                |
| Monitoring              | Prometheus, Grafana, CloudWatch |
| Autoscaling             | Kubernetes HPA                  |
| Notifications           | Amazon SNS                      |
| Version Control         | Git, GitHub                     |
| OS / Scripting          | Linux, Shell                    |

---

# 🌍 Environments

The project supports three environments:

```text
Dev
 │
 ▼
Staging
 │
 ▼
Production
```

Each environment has its own Terraform configuration and remote state.

Terraform state is stored in **Amazon S3**, with **DynamoDB state locking** to prevent concurrent state modifications.

---

# 🔄 CI/CD Workflow

## GitHub Actions — CI

GitHub Actions performs the CI activities when code is pushed to the appropriate branch.

The pipeline includes:

1. Checkout source code
2. Terraform formatting validation
3. Terraform validation
4. Terraform plan
5. Docker image build
6. Docker image push to Amazon ECR
7. EKS deployment for the production/main workflow

Production Terraform execution is manually triggered and protected through the GitHub production environment approval.

---

## Jenkins — CD

Jenkins is used for deployment and infrastructure operations.

The Jenkins pipeline supports:

* Environment selection
* Terraform Apply
* Terraform Destroy
* AWS authentication
* ECR integration
* Environment-specific configuration
* Secure credential handling

This separates CI activities from deployment and infrastructure operations.

---

# 🐳 Docker

The backend application is containerized using Docker.

Docker images are pushed to Amazon ECR using environment-specific and commit-based image tags.

Example:

```text
dev-<commit>
staging-<commit>
prod-<commit>
```

This allows application versions to be identified by the Git commit that produced the image.

---

# ☁️ AWS Infrastructure

Terraform provisions the required AWS infrastructure, including:

* VPC and networking
* EC2
* Amazon RDS MySQL
* IAM
* Amazon S3
* CloudWatch
* SNS
* EC2 key pair

Terraform modules are used to keep the infrastructure reusable and organized.

---

# ☸️ Phase 2 — Kubernetes & Amazon EKS

Phase 2 extends the Docker-based deployment into a Kubernetes-based container orchestration platform using **Amazon EKS**.

## EKS Components

The Kubernetes implementation includes:

* **Amazon EKS** — managed Kubernetes cluster
* **Managed Node Group** — worker nodes for Kubernetes workloads
* **Kubernetes Deployment** — manages backend application pods
* **Kubernetes Service** — provides stable internal networking
* **Amazon ECR** — stores Docker images
* **Kubernetes Secrets** — stores database configuration
* **Metrics Server** — provides resource metrics
* **Prometheus** — collects Kubernetes and infrastructure metrics
* **Grafana** — visualizes monitoring data
* **Horizontal Pod Autoscaler** — automatically scales backend replicas

---

# 🔄 GitHub Actions → EKS Deployment

The GitHub Actions workflow builds and pushes the Docker image to Amazon ECR.

For the main branch, the workflow then updates the Kubernetes deployment with the newly built image.

```text
Git Push
   │
   ▼
GitHub Actions
   │
   ├── Checkout
   ├── AWS Authentication
   ├── Docker Build
   └── Docker Push
          │
          ▼
       Amazon ECR
          │
          ▼
       Amazon EKS
          │
          ▼
 Kubernetes Deployment
          │
          ▼
     Backend Pods
```

AWS authentication for GitHub Actions uses an **IAM role with GitHub OIDC** rather than storing long-lived AWS access keys in GitHub.

---

# 📈 Kubernetes Autoscaling

The backend deployment uses Kubernetes resource requests and limits.

The Horizontal Pod Autoscaler is configured as:

```text
Minimum replicas: 1
Maximum replicas: 3
CPU target: 50%
```

During load testing, the HPA successfully scaled the backend:

```text
1 replica
    │
    │ CPU load
    ▼
2 replicas
    │
    ▼
3 replicas
```

Observed CPU utilization exceeded the configured 50% target, reaching values such as:

```text
139% / 50%
500% / 50%
```

All three backend replicas successfully reached the `Running` state.

After the load stopped, CPU utilization returned to:

```text
0% / 50%
```

This verified that Kubernetes HPA was correctly connected to the Metrics Server and capable of scaling the application workload.

---

# 📊 Monitoring

## Prometheus

Prometheus is used to collect Kubernetes and infrastructure metrics.

The project uses the **kube-prometheus-stack** for monitoring components.

Prometheus collects metrics from components such as:

* Kubernetes workloads
* Nodes
* Pods
* Kubernetes resources
* Node Exporter
* Kubernetes State Metrics

---

## Grafana

Grafana is integrated with Prometheus as the metrics data source.

Dashboards provide visibility into:

* Cluster resources
* Node utilization
* Pod resources
* Workloads
* Kubernetes resources
* Prometheus metrics

The monitoring workflow is:

```text
Kubernetes
    │
    ▼
Prometheus
    │
    ▼
Grafana
    │
    ▼
Dashboards
```

---

## AWS Monitoring

AWS CloudWatch is used for application and infrastructure logging.

SNS is configured for alert notifications.

This provides visibility into the AWS infrastructure and allows notifications to be triggered for configured monitoring events.

---

# 🔐 Security

Sensitive configuration is intentionally excluded from the repository.

The project uses:

* GitHub Secrets
* Jenkins Credentials
* AWS IAM
* GitHub OIDC authentication
* Kubernetes Secrets
* `.gitignore` for sensitive files
* Terraform remote state
* Environment-specific variables

Passwords, `.tfvars`, `.env`, private keys, and Terraform state files are not committed to Git.

---

# 📁 Repository Structure

```text
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
├── k8s/
│   ├── backend-deployment.yml
│   ├── backend-service.yml
│   ├── backend-hpa.yml
│   └── github-actions-rbac.yml
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
```

---

# 🎯 Project Goals

This project demonstrates practical knowledge of:

* Infrastructure as Code
* AWS infrastructure provisioning
* Terraform modules
* Terraform remote state
* CI/CD pipeline design
* Docker containerization
* GitHub Actions
* Jenkins
* Amazon ECR
* Amazon EKS
* Kubernetes
* Kubernetes deployments and services
* Kubernetes autoscaling
* Prometheus
* Grafana
* CloudWatch
* SNS
* Multi-environment deployments
* Secure credential management
* GitHub OIDC authentication

---

# 🏁 Project Outcome

The completed project demonstrates an end-to-end DevOps workflow:

```text
Developer
    │
    ▼
GitHub
    │
    ├───────────────┐
    ▼               ▼
GitHub Actions    Jenkins
    │               │
    ▼               ▼
Docker            Terraform
    │               │
    ▼               ▼
Amazon ECR       AWS Infrastructure
    │
    ▼
Amazon EKS
    │
    ▼
Kubernetes
    │
    ├── Deployment
    ├── Service
    └── HPA
         │
         ▼
     Prometheus
         │
         ▼
      Grafana
         │
         ▼
      AWS RDS
```

**Project:** Full DevOps Pipeline on AWS
**Focus:** AWS • Terraform • Docker • GitHub Actions • Jenkins • ECR • EKS • Kubernetes • Prometheus • Grafana • HPA
