pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'docker.io/dockerqwert123/testimg'  // Update with your Docker Hub username
        DOCKER_TAG = 'gp2'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDS = 'docker'  // Jenkins credentials ID for Docker login
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to Docker Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    bat "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}"
                    bat "docker info"  // Optional: Check Docker login status
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    bat "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }

    post {
        always {
            bat 'docker system prune -f'
        }
    }
}
