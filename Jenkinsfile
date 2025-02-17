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

                sh '/bin/bash -c "kubectl apply -f kubernetes/service.yaml"'

                // Wait for deployment to become available
                sh '/bin/bash -c "kubectl rollout status deployment/si-sharp-1 --timeout=5m"'

                // sh '/bin/bash -c "kubectl apply -f kubernetes/service.yaml && kubectl rollout status deployment/si-sharp-1"'
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
