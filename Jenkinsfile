pipeline {
    agent any

    environment {
        DOTNET_ROOT = "/opt/homebrew/bin"
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        SHELL = "/bin/bash"   // Explicitly set shell
    }

    stages {
        stage('Restore NuGet Packages') {
            steps {
                sh '/bin/bash -c "dotnet restore"'
            }
        }
        stage('Build') {
            steps {
                sh '/bin/bash -c "dotnet build -c Release"'
            }
        }
        stage('Run Unit Tests') {
            steps {
                sh '/bin/bash -c "dotnet test"'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '/bin/bash -c "docker build -t si-sharp-1-image:latest -f Dockerfile ."'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // Apply the Kubernetes service definition
                sh '/bin/bash -c "kubectl apply -f kubernetes/service.yaml"'

                // Retry logic for checking rollout status
                script {
                    def maxRetries = 10  // Max retries
                    def retries = 0
                    def success = false
                    while (retries < maxRetries && !success) {
                        retries++
                        try {
                            // Check if deployment is successful
                            sh '/bin/bash -c "kubectl rollout status deployment/si-sharp-1 --timeout=5m"'
                            success = true
                        } catch (Exception e) {
                            echo "Attempt ${retries} failed. Deployment not yet available. Retrying..."
                            sleep(time: 30, unit: 'SECONDS')  // Retry after a delay
                        }
                    }
                    if (!success) {
                        error "Deployment rollout failed after ${maxRetries} retries."
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline successful!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
