pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ramyacloud001/intellipaat-capstone1"
        DOCKER_REGISTRY = "docker.io"  // Default registry for Docker Hub
        APP_CONTAINER_NAME = "webapp_container"
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
                    sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:${BUILD_ID}"

                    // Add test commands here, such as:
                    // sh "curl -I http://localhost:80"

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
