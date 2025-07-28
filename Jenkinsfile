pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "holuphilix/jenkins-cicd-app:latest"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        SSH_CREDENTIALS_ID = 'EC2_SSH_KEY'
        EC2_HOST = credentials('EC2_HOST') // Secret Text type in Jenkins Credentials
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                echo "🧾 Checking out code..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image: ${DOCKER_IMAGE}"
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "📦 Pushing image to Docker Hub..."
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo "🚀 Deploying to EC2 instance..."
                sshagent (credentials: [SSH_CREDENTIALS_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} '
                            cd ~/jenkins-cicd-app/deployment-scripts &&
                            chmod +x deploy.sh &&
                            ./deploy.sh
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
