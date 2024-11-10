pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ramyacloud001/intellipaat-capstone2"
        DOCKER_REGISTRY = "docker.io"
        APP_CONTAINER_NAME = "webapp_container_${BUILD_ID}"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Current Branch: ${env.BRANCH_NAME}"
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_ID} ."
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Running tests in Docker container..."
                    // Stop and remove any existing container with the same name
                    sh "docker ps -q --filter name=${APP_CONTAINER_NAME} | grep -q . && docker stop ${APP_CONTAINER_NAME} && docker rm ${APP_CONTAINER_NAME} || true"
                    
                    // Run the Docker container for testing
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
                    echo "Tagging Docker image for deployment..."
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_ID} ${DOCKER_IMAGE}:latest"

                    echo "Pushing Docker image to Docker Hub..."
                    sh "docker push ${DOCKER_IMAGE}:latest"

                    echo "Deploying application..."
                    sh "docker-compose -f docker-compose.yml up -d"
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
