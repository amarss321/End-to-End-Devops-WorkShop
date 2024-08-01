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
    
    stages{
        stage("Checkout SCM"){
            steps{
                git branch: 'main', url: 'https://github.com/amarss321/End-to-End-Devops-WorkShop.git'
            }
            
        }
        stage('SonarQube Analysis') {
        script{
            def mvn = tool 'Maven';
            withSonarQubeEnv(installationName: 'sonar-server') {
                sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=end-to-end-devops-project"
                }
            }
        }
    }
}
    