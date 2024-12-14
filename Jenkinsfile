pipeline {
    agent none

    stages {
        stage('Test Node Operations') {
            agent {
                label 'test-node-label'
            }
            steps {
                script {
                    echo "Running on Test Node..."

                    // Clean and clone the repository into the test workspace
                    sh 'rm -rf /var/lib/jenkins/workspace/test/*'
                    sh 'git clone -b develop https://github.com/ramyacloud001/intellipaat-azuredevops-capstone1.git /var/lib/jenkins/workspace/test'

                    // Simulate test operations
                    echo "Executing tests on Test Node..."
                    sh 'cd /var/lib/jenkins/workspace/test && echo "Tests executed successfully!"'
                }
            }
        }

        stage('Prod Node Operations') {
            agent {
                label 'prod-node-label'
            }
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                script {
                    echo "Running on Prod Node..."

                    // Clean and copy files to the prod node workspace
                    sh 'rm -rf /var/lib/jenkins/workspace/prod/*'
                    sh 'cp -r /var/lib/jenkins/workspace/test/* /var/lib/jenkins/workspace/prod'

                    // Simulate deployment operations
                    echo "Deploying application on Prod Node..."
                    sh 'cd /var/lib/jenkins/workspace/prod && echo "Application deployed successfully!"'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
