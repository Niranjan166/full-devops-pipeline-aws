# 📄 Full DevOps Pipeline for a Document Management System (DMS)

A full-stack **Document Management System (DMS)** built to demonstrate modern DevOps practices, including containerization, Infrastructure as Code (IaC), Continuous Integration/Continuous Deployment (CI/CD), cloud deployment, and monitoring.

The project starts with a simple but functional application and progressively evolves into a production-style deployment using Docker, Terraform, AWS, Jenkins, and Kubernetes.

---

# 🚀 Project Goals

This project is designed to demonstrate end-to-end DevOps implementation by:

* Building a full-stack web application
* Containerizing the application using Docker
* Automating infrastructure provisioning using Terraform
* Deploying to AWS
* Implementing CI/CD using Jenkins
* Monitoring the application
* Deploying to Kubernetes (Phase 2)

---

# 🏗️ Current Features

### Authentication

* Secure Login
* JWT Authentication
* Password Hashing using bcrypt
* Logout

### Document Management

* Upload Documents
* View Uploaded Documents
* Delete Documents

---

# 🛠️ Tech Stack

## Frontend

* React
* Vite
* Axios

## Backend

* Node.js
* Express.js
* JWT Authentication
* bcrypt
* Multer

## Database

* MySQL

---

# 📁 Project Structure

```text
full-devops-pipeline-aws/

├── application/
│   ├── backend/
│   └── frontend/
│
├── terraform/
├── ansible/
├── jenkins/
├── docker/
│
├── README.md
└── .gitignore
```

---

# ⚙️ Getting Started

## Clone Repository

```bash
git clone <repository-url>
```

## Backend

```bash
cd application/backend
npm install
npm run dev
```

## Frontend

```bash
cd application/frontend
npm install
npm run dev
```

---

# 🔐 Environment Variables

Create a `.env` file inside the backend directory.

Example:

```env
PORT=5000

DB_HOST=localhost
DB_PORT=3306
DB_USER=your_username
DB_PASSWORD=your_password
DB_NAME=your_database

JWT_SECRET=your_secret_key
```

---

# 📌 API Endpoints

## Authentication

| Method | Endpoint      | Description |
| ------ | ------------- | ----------- |
| POST   | `/auth/login` | User Login  |

---

## Documents

| Method | Endpoint         | Description       |
| ------ | ---------------- | ----------------- |
| GET    | `/documents`     | Get All Documents |
| POST   | `/documents`     | Upload Document   |
| DELETE | `/documents/:id` | Delete Document   |

---

# 📅 Development Roadmap

## ✅ Phase 1 - Application Development

* React Frontend
* Express Backend
* MySQL Database
* JWT Authentication
* File Upload
* Document Management

## 🚧 Phase 2 - Containerization

* Docker
* Docker Compose

## 🚧 Phase 3 - Infrastructure as Code

* Terraform Modules
* AWS Infrastructure
* IAM
* VPC
* EC2
* RDS
* S3

## 🚧 Phase 4 - CI/CD

* Jenkins
* GitHub Integration
* Automated Build
* Automated Deployment

## 🚧 Phase 5 - Monitoring

* CloudWatch
* Application Logs

## 🚧 Phase 6 - Kubernetes

* Docker Images
* Kubernetes Deployment
* Kubernetes Services
* AWS EKS

---

# 🎯 Purpose of this Project

The primary objective of this project is to gain hands-on experience with DevOps tools and practices by building and deploying a complete full-stack application using industry-standard technologies.

---

# 📜 License

This project is intended for educational and portfolio purposes.
