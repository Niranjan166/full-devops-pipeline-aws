pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Select terraform environment'
        )
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose the Terraform action to perform'
        )
    }

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
                        bat 'if exist environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars del /q environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars'
                        bat 'terraform fmt -check -recursive -diff'
                        bat 'terraform init'
                        bat 'terraform validate'
                        withCredentials([string(credentialsId: 'dms-db-password', variable: 'DB_PASSWORD')]) {
                            bat '''
                                echo environment = "%ENVIRONMENT%" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo aws_region = "us-east-1" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo project_name = "dms" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo vpc_cidr = "10.0.0.0/16" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo az_count = 2 >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo instance_type = "t3.micro" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo key_pair_name = "dms-%ENVIRONMENT%-key" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo lifecycle_days = 30 >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo db_name = "dms_db" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo db_username = "admin" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo db_password = "%DB_PASSWORD%" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo db_instance_class = "db.t3.micro" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                                echo alert_email = "niranjan01125@gmail.com" >> environments\\%ENVIRONMENT%\\%ENVIRONMENT%.tfvars
                            '''
                        }
                        bat 'terraform plan -var-file="environments/%ENVIRONMENT%/%ENVIRONMENT%.tfvars"'

                        bat '''
                            if "%Terraform actions%" == "apply" (
                                terraform apply -var-file="environments/%ENVIRONMENT%/%ENVIRONMENT%.tfvars" -auto-approve
                            ) else (
                                terraform destroy -var-file="environments/%ENVIRONMENT%/%ENVIRONMENT%.tfvars" -auto-approve
                            )
                        '''
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