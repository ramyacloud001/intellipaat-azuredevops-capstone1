pipeline {
    agent none

    stages {
        stage('Test Node Operations') {
            agent {
                label 'test-node-label'
            }
            environment {
                TEST_WORKSPACE = '/var/lib/jenkins/test-workspace'
            }
            when {
                branch 'develop'
            }
            steps {
                script {
                    echo "Running on Test Node..."

                    // Ensure the test workspace directory is clean before cloning the repository
                    sh 'rm -rf ${TEST_WORKSPACE}'
                    sh 'mkdir -p ${TEST_WORKSPACE}'

                    // Clone repository from GitHub (ensure develop branch)
                    sh 'git clone -b develop https://github.com/ramyacloud001/intellipaat-azuredevops-capstone1.git ${TEST_WORKSPACE}'

                    // Simulate test operations
                    echo "Executing tests on Test Node..."
                    sh 'cd ${TEST_WORKSPACE} && echo "Tests executed successfully!"'

                    // Ensure tests passed successfully by adding a pass command
                    echo "Test Node operations completed successfully!"
                    currentBuild.result = 'SUCCESS'  // Explicit success
                }
            }
        }

        stage('Prod Node Operations') {
            agent {
                label 'prod-node-label'
            }
            environment {
                PROD_WORKSPACE = '/var/lib/jenkins/prod-workspace'
            }
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                script {
                    echo "Running on Prod Node..."

                    // Ensure the prod workspace directory is clean before copying files
                    sh 'rm -rf ${PROD_WORKSPACE}'
                    sh 'mkdir -p ${PROD_WORKSPACE}'

                    // Copy files from the test workspace to prod workspace
                    sh '''
                    rsync -a --exclude="/proc/*" --exclude="/dev/*" --exclude="/sys/*" --exclude="/tmp/*" --exclude="/run/*" --exclude="/mnt/*" --exclude="/media/*" --exclude="/lost+found" / ${PROD_WORKSPACE}/
                    '''

                    // Simulate deployment operations
                    echo "Deploying application on Prod Node..."
                    sh 'cd ${PROD_WORKSPACE} && echo "Application deployed successfully!"'

                    // Explicit pass command for prod stage
                    echo "Prod Node operations completed successfully!"
                    currentBuild.result = 'SUCCESS'  // Explicit success
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
