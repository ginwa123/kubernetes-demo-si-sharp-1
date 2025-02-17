pipeline {
    agent any

    environment {
        DOTNET_ROOT = "/opt/homebrew/bin"
        PATH = "/opt/homebrew/bin:$PATH"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ginwa123/kubernetes-demo-si-sharp-1.git'
            }
        }
        stage('Restore NuGet Packages') {
            steps {
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                dotnet restore
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                dotnet build -c Release
                '''
            }
        }
        stage('Run Unit Tests') {
            steps {
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                dotnet test
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                docker build -t si-sharp-1-image:latest -f Dockerfile .
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                kubectl apply -f kubernetes/service.yaml
                kubectl rollout status deployment/si-sharp-1
                '''
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
