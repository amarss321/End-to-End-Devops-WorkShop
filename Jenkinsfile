pipeline{
    agent {
        label 'dev-slave'
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '30', numToKeepStr: '2')
    }
    tools {
        maven 'Maven'
    }
    environment {
        cred = credentials('aws-cred')
        IMAGE_NAME = "590184028154.dkr.ecr.us-east-1.amazonaws.com/addressbook"
        IMAGE_VERSION = "$BUILD_NUMBER"
    }

    stages{
        stage("Checkout SCM"){
            steps{
                git branch: 'main', url: 'https://github.com/amarss321/End-to-End-Devops-WorkShop.git'
            }
            
        }
        stage('SonarQube Analysis') {
            steps{
                script{
                    def mvn = tool 'Maven';
                    withSonarQubeEnv(installationName: 'sonar-server') {
                        sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=end-to-end-devops-project"
                    }
                }
            }
        }
        stage('Build'){
            steps{
                sh 'mvn package'
            }
        }
        stage('Nexus Push'){
            steps{
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '54.210.36.4',
                    groupId: 'addressbook',
                    version: '2.0-SNAPSHOT',
                    repository: 'maven-snapshots',
                    credentialsId: 'nexus-cred',
                    artifacts: [
                        [artifactId: 'DEV',
                        classifier: '',
                        file: 'target/addressbook-2.0.war',
                        type: 'war']
                     ]
                )
            }
        }
        stage('Docker Image Build'){
            steps{
                sh 'docker build -t ${IMAGE_NAME}:v.1.${IMAGE_VERSION} .'
                sh 'docker images'
            }
        }
        stage('Push Docker Image to AWS ECR'){
            steps{
                sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 590184028154.dkr.ecr.us-east-1.amazonaws.com                   
                    docker tag ${IMAGE_NAME}:v.1.${IMAGE_VERSION} ${IMAGE_NAME}:latest
                    docker push ${IMAGE_NAME}:latest
                    docker images
                '''
            }
        }
    }
}
    