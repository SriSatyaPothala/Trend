pipeline{
    agent any
    environment{}
    stages{
        stage('Build Docker Image and push to docker hub')
        stage('Update Image tag in Remote repository')
        stage('Deploy the application using AWS EKS')
    }
}