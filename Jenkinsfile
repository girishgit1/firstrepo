pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'docker.io/dockerqwert123/testimg'  // Update with your Docker Hub username
        DOCKER_TAG = 'gp2'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDS = 'docker'  // Jenkins credentials ID for Docker login
        EC2_SSH_CREDENTIALS = 'sshkey'  // Replace with the name you gave your credentials in Jenkins
        EC2_INSTANCE_IP = '34.219.0.193'  // Replace with your EC2 instance's public IP
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

        stage('Deploy to EC2') {
            steps {
                script {
                    // Use SSH credentials to access EC2 instance and run commands
                    sshagent([EC2_SSH_CREDENTIALS]) {
                        // SSH into EC2 and run the Docker commands
                        sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@${EC2_INSTANCE_IP} "docker pull ${DOCKER_IMAGE}:${DOCKER_TAG} && docker run -d -p 8080:80 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            bat 'docker system prune -f'  // Clean up Docker system (optional)
        }
    }
}
