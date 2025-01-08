pipeline {
    agent any
    
    environment {
        // Define environment variables for image name and version
        DOCKER_IMAGE = 'testimg'
        DOCKER_TAG = 'latest'
        DOCKER_REGISTRY = 'docker.io'  // You can change this if using a private registry
        DOCKER_CREDS = 'docker'  // Jenkins credentials ID for Docker login
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the defined variables
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }
        
        stage('Login to Docker Registry') {
            steps {
                // Login to Docker registry using the credentials stored in Jenkins
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to the Docker registry
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker resources after the build, if needed
            sh 'docker system prune -f'
        }
    }
}
