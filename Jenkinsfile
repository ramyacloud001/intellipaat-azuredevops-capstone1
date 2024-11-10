pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ramyacloud001/intellipaat-capstone2"
        DOCKER_REGISTRY = "docker.io"
        APP_CONTAINER_NAME = "webapp_container"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    if (env.BRANCH_NAME == 'master') {
                        sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    } else if (env.BRANCH_NAME == 'develop') {
                        sh "docker build -t ${DOCKER_IMAGE}:${env.BRANCH_NAME}-${BUILD_ID} ."
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Running tests in Docker container..."
                    if (env.BRANCH_NAME == 'master') {
                        sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:latest"
                    } else if (env.BRANCH_NAME == 'develop') {
                        sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:${env.BRANCH_NAME}-${BUILD_ID}"
                    }
                    
                    // Example test command
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
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:prod"

                    echo "Pushing Docker image to Docker Hub..."
                    sh "docker push ${DOCKER_IMAGE}:prod"

                    echo "Deploying application..."
                    sh "docker-compose -f docker-compose.yml up -d"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Docker environment..."
            sh "docker rmi ${DOCKER_IMAGE}:latest || true"
            sh "docker rmi ${DOCKER_IMAGE}:${env.BRANCH_NAME}-${BUILD_ID} || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}
