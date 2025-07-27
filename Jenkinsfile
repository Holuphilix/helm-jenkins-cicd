pipeline {
    agent any

    environment {
        AWS_REGION       = 'us-east-1'
        IMAGE_NAME       = 'holuphilix/jenkins-cicd-app'
        IMAGE_TAG        = 'latest'
        DOCKER_IMAGE     = "${IMAGE_NAME}:${IMAGE_TAG}"
        DOCKERFILE_PATH  = './deployment-scripts/Dockerfile'
        DEPLOY_SCRIPT    = './deployment-scripts/deploy.sh'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Holuphilix/helm-jenkins-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -f ${DOCKERFILE_PATH} -t ${DOCKER_IMAGE} ./deployment-scripts"
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deploy to EC2 Server') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-iam-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script {
                        sh "chmod +x ${DEPLOY_SCRIPT}"
                        sh "${DEPLOY_SCRIPT}"
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo '✅ Deployment pipeline completed successfully!'
        }
        failure {
            echo '❌ Deployment failed. Please check the logs.'
        }
    }
}
