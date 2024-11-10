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
                    // Build the image with the appropriate tag based on branch name
                    sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Running tests in Docker container..."
                    try {
                        // Run the container with the appropriate tag
                        sh "docker run --rm -d --name ${APP_CONTAINER_NAME} ${DOCKER_IMAGE}:${IMAGE_TAG}"

                        // Sleep for 15 seconds to allow the container to fully start
                        sleep(15)

                        // Check the status of the container
                        sh "docker ps -a --filter name=${APP_CONTAINER_NAME}"

                        // Check container logs for errors
                        sh "docker logs ${APP_CONTAINER_NAME}"

                        // Example test command, such as a curl request to check the app is up
                        // sh "curl -I http://localhost:80"
                    } catch (Exception e) {
                        echo "Error running Docker container: ${e.message}"
                        currentBuild.result = 'FAILURE'
                    } finally {
                        // Attempt to stop the container if it is running
                        sh "docker ps -q --filter name=${APP_CONTAINER_NAME} | grep -q . && docker stop ${APP_CONTAINER_NAME} || echo 'No such container: ${APP_CONTAINER_NAME}'"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Tagging Docker image for deployment..."
                    // Tag the image as prod for deployment
                    sh "docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:prod"

                    echo "Pushing Docker image to Docker Hub..."
                    // Push the prod image to Docker registry
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
                // Clean up images after use
                sh "docker rmi ${DOCKER_IMAGE}:${IMAGE_TAG} || true"
                sh "docker rmi ${DOCKER_IMAGE}:prod || true"
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
