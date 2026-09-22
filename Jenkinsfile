pipeline {
    agent any

    environment {
        IMAGE_NAME = "dms-backend"
        ECR_REGISTRY = "371397858660.dkr.ecr.eu-north-1.amazonaws.com"
        ECR_REPOSITORY = "371397858660.dkr.ecr.eu-north-1.amazonaws.com/dms-backend"
        AWS_REGION = "eu-north-1"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                bat 'node --version'
                bat 'npm --version'
                bat 'docker --version'
                bat 'aws --version'
                bat 'terraform --version'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir('application/backend') {
                    bat 'npm install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:%BUILD_NUMBER% application/backend'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'ID: aws-ecr-credentials']
                ]) { 
                    bat 'aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REGISTRY%'
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                bat 'docker tag %IMAGE_NAME%:%BUILD_NUMBER% %ECR_REPOSITORY%:%BUILD_NUMBER%'
                bat 'docker push %ECR_REPOSITORY%:%BUILD_NUMBER%'
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('terraform') {
                    bat 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform plan -var-file="environments/dev/dev.tfvars"'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }

        failure {
            echo "Pipeline failed. Check console output."
        }

        always {
            echo "Build Number: ${BUILD_NUMBER}"
        }
    }
}