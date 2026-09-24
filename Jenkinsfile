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

        stage('AWS Deployment Pipeline') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'ID: aws-ecr-credentials']
                ]) { 
                    bat 'aws sts get-caller-identity'
                    bat 'aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REGISTRY%'
                    bat 'docker tag %IMAGE_NAME%:%BUILD_NUMBER% %ECR_REPOSITORY%:%BUILD_NUMBER%'
                    bat 'docker push %ECR_REPOSITORY%:%BUILD_NUMBER%'

                    dir('terraform') {
                        bat 'if exist environments\\dev\\dev.tfvars del /q environments\\dev\\dev.tfvars'
                        bat 'terraform fmt -check -recursive -diff'
                        bat 'terraform init'
                        bat 'terraform validate'
                        withCredentials([string(credentialsId: 'dms-db-password', variable: 'DB_PASSWORD')]) {
                            bat '''
                                echo environment = "dev" >> environments\\dev\\dev.tfvars
                                echo aws_region = "us-east-1" >> environments\\dev\\dev.tfvars
                                echo project_name = "dms" >> environments\\dev\\dev.tfvars
                                echo vpc_cidr = "10.0.0.0/16" >> environments\\dev\\dev.tfvars
                                echo az_count = 2 >> environments\\dev\\dev.tfvars
                                echo instance_type = "t3.micro" >> environments\\dev\\dev.tfvars
                                echo key_pair_name = "dms-dev-key" >> environments\\dev\\dev.tfvars
                                echo lifecycle_days = 30 >> environments\\dev\\dev.tfvars
                                echo db_name = "dms_db" >> environments\\dev\\dev.tfvars
                                echo db_username = "admin" >> environments\\dev\\dev.tfvars
                                echo db_password = "%DB_PASSWORD%" >> environments\\dev\\dev.tfvars
                                echo db_instance_class = "db.t3.micro" >> environments\\dev\\dev.tfvars
                                echo alert_email = "niranjan01125@gmail.com" >> environments\\dev\\dev.tfvars
                            '''
                        }
                        bat 'terraform plan -var-file="environments/dev/dev.tfvars"'
                        // Apply infrastructure
                        // bat 'terraform apply -var-file="environments/dev/dev.tfvars" -auto-approve'

                        // Destroy infrastructure when testing is complete
                        bat 'terraform destroy -var-file="environments/dev/dev.tfvars" -auto-approve'
                    }
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