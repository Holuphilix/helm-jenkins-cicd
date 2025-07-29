pipeline {
    agent any

    environment {
        ECR_REPO_URL = '615299759133.dkr.ecr.us-east-1.amazonaws.com/jenkins-cicd-app'
        AWS_REGION = 'us-east-1'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DEPLOY_SCRIPT = 'deployment-scripts/deploy.sh'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Holuphilix/helm-jenkins-cicd.git', branch: 'main'
            }
        }

        stage('Set up AWS Credentials') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                        echo "AWS credentials configured."
                    '''
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REPO_URL
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $ECR_REPO_URL:$IMAGE_TAG -f deployment-scripts/Dockerfile .
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker push $ECR_REPO_URL:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EKS with Helm') {
            steps {
                sh '''
                    chmod +x $DEPLOY_SCRIPT
                    $DEPLOY_SCRIPT $ECR_REPO_URL:$IMAGE_TAG $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
