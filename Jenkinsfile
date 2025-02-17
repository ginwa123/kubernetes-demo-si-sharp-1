pipeline {
    agent any

    environment {
        DOTNET_ROOT = "/opt/homebrew/bin"
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        SHELL = "/bin/bash"   // Explicitly set shell
        NAMESPACE = "argo-demo"  // Define your Kubernetes namespace
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

                // Remove any old images (not 'latest')
               script {
            // Get all image IDs for si-sharp-1-image except the latest
                    def oldImages = sh(script: '/bin/bash -c "docker images -q si-sharp-1-image | grep -v $(docker images -q si-sharp-1-image:latest)"', returnStdout: true).trim()

                    // If old images exist, remove them
                    if (oldImages) {
                        sh "/bin/bash -c 'docker rmi ${oldImages} || true'"
                    }
                }

                sh '/bin/bash -c "docker build --no-cache -t si-sharp-1-image:latest -f Dockerfile ."'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // Apply the service
                sh '/bin/bash -c "kubectl apply -f kubernetes/service.yaml -n $NAMESPACE"'
                // Wait for deployment to become available with retry
                script {
                    def retryCount = 5
                    def deploymentAvailable = false

                    // Retry mechanism to check deployment status
                    retry(retryCount) {
                        sh '/bin/bash -c "kubectl rollout status deployment/si-sharp-1 -n $NAMESPACE --timeout=5m"'
                        // sh '/bin/bash -c "kubectl -n argocd patch application si-sharp-1 --type merge -p \'{\"status\": {\"sync\": {\"status\": \"Syncing\"}}}\'"'
                        deploymentAvailable = true
                    }

                    if (!deploymentAvailable) {
                        error "Deployment was not ready after $retryCount attempts."
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
