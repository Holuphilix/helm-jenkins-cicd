pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '615299759133.dkr.ecr.us-east-1.amazonaws.com/jenkins-cicd-app' 
        IMAGE_TAG = "latest"
        HELM_CHART_PATH = "./web-app/my-web-app/"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        DOCKER_IMAGE = "${ECR_REGISTRY}:${IMAGE_TAG}"
        DOCKERFILE_PATH = "./web-app/Dockerfile"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Holuphilix/helm-jenkins-cicd.git'
            }
        }

        stage('Lint Helm Chart') {
            steps {
                sh 'helm lint ${HELM_CHART_PATH}'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -f ${DOCKERFILE_PATH} -t ${DOCKER_IMAGE} ./web-app"
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-iam-credentials', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    script {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh "helm upgrade --install my-web-app ${HELM_CHART_PATH} --namespace default --set image.repository=${ECR_REGISTRY} --set image.tag=${IMAGE_TAG} --set replicaCount=2"
            }
        }

        stage('Test Deployment') {
            steps {
                sh 'helm test my-web-app --namespace default'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
