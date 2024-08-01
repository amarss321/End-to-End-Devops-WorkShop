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
        IMAGE_NAME = "addressbook"
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
    }
}
    