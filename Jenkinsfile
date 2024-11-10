pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ramyacloud001/intellipaat-capstone2"
        DOCKER_REGISTRY = "docker.io"  // Default registry for Docker Hub
        APP_CONTAINER_NAME = "webapp_container"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Build Docker image from Dockerfile
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_ID} ."
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run the Docker container for testing
                    echo "Running tests in Docker container..."
                    sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:${BUILD_ID}"

                    // Add test commands here, such as:
                    // sh "curl -I http://localhost:80"

                    // Stop the container after tests
                    sh "docker stop ${APP_CONTAINER_NAME}"
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                script {
                    // Tag the image for deployment
                    echo "Tagging Docker image for deployment..."
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_ID} ${DOCKER_IMAGE}:latest"

                    // Push the image to Docker Hub
                    echo "Pushing Docker image to Docker Hub..."
                    sh "docker push ${DOCKER_IMAGE}:latest"

                    // Deploy the image using Docker Compose (for local deployment)
                    echo "Deploying application..."
                    sh "docker-compose -f docker-compose.yml up -d"

                    // Alternatively, if deploying to a cloud service (e.g., Azure, AWS), use respective CLI commands.
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Docker environment..."
            sh "docker rmi ${DOCKER_IMAGE}:${BUILD_ID} || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}
