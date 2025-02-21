pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
    }
    
    stages {
        stage('Set Environment') {
            steps {
                script {
                    echo "Detected Branch Name: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init -backend-config="key=infrastructure/${env.BRANCH_NAME}/terraform.tfstate" -no-color'
                }
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -var-file="environments/${env.BRANCH_NAME}.tfvars" -out=tfplan -no-color'
                }
            }
        }

        stage('Approval') {
            when {
                expression { env.BRANCH_NAME == 'prod' }
            }
            steps {
                input message: 'Do you want to apply this plan?'
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Infrastructure successfully deployed!'
        }
        failure {
            echo 'Infrastructure deployment failed!'
        }
    }
} 