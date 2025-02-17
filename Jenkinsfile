pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                 git branch: 'main',
                    url: 'https://github.com/ginwa123/kubernetes-demo-si-sharp-1.git'
            }
        }
        stage('Restore NuGet Packages') {
            steps {
               sh '/opt/homebrew/bin/dotnet restore'
            }
        }
        stage('Build') {
            steps {
                sh '/opt/homebrew/bin/dotnet build -c Release'
            }
        }
        stage('Run Unit Tests') {
            steps {
                sh '/opt/homebrew/bin/dotnet test'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t si-sharp-1-image:latest -f Dockerfile .'
            }
        }
        // stage('Push Docker Image') {
        //     steps {
        //         sh 'docker tag myapp:latest yourdockerhubusername/myapp:latest'
        //         sh 'docker push yourdockerhubusername/myapp:latest'
        //     }
        // }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f kubernetes/service.yaml'
                sh 'kubectl rollout status deployment/si-sharp-1'
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