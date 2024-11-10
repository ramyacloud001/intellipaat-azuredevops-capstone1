pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ramyacloud001/intellipaat-capstone2"
        DOCKER_REGISTRY = "docker.io"
        APP_CONTAINER_NAME = "webapp_container"
        IMAGE_TAG = "${env.BRANCH_NAME}-${BUILD_ID}"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    if (env.BRANCH_NAME == 'master') {
                        // Build the image with 'latest' tag for master branch
                        sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    } else if (env.BRANCH_NAME == 'develop') {
                        // Build the image with 'dev' tag for develop branch
                        sh "docker build -t ${DOCKER_IMAGE}:dev ."
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Running tests in Docker container..."
                    try {
                        if (env.BRANCH_NAME == 'master') {
                            sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:latest"
                        } else if (env.BRANCH_NAME == 'develop') {
                            sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:dev"
                        }

                        // Example test command
                        // sh "curl -I http://localhost:80"
                    } finally {
                        sh "docker ps -q --filter name=${APP_CONTAINER_NAME} | grep -q . && docker stop ${APP_CONTAINER_NAME} || echo 'No such container: ${APP_CONTAINER_NAME}'"
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                script {
                    echo "Tagging Docker image for production deployment..."
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:prod"

                    echo "Pushing Docker image to Docker Hub..."
                    sh "docker push ${DOCKER_IMAGE}:prod"

                    echo "Deploying application to production..."
                    // Assuming docker-compose for deployment in production
                    sh "docker-compose -f docker-compose.yml up -d"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Docker environment..."
            script {
                if (env.BRANCH_NAME == 'master') {
                    // Clean up the latest image after use in master branch
                    sh "docker rmi ${DOCKER_IMAGE}:latest || true"
                    sh "docker rmi ${DOCKER_IMAGE}:prod || true"
                } else if (env.BRANCH_NAME == 'develop') {
                    // Clean up the dev image after use in develop branch
                    sh "docker rmi ${DOCKER_IMAGE}:dev || true"
                }
            }
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}
