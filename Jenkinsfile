pipeline {
    agent any
    environment {
        APP_NAME    = "flask-application"
        PORT        = "5000:5000"
        IMAGE_NAME  = "deflorioan/flask-calculator"
        IMAGE_TAG   = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }
    
    stages {
        stage('Checkout') {
            steps{
                sh 'git clone https://github.com/deflorioan/flask-app'
            }
        }
        stage('Testing') {
            steps{
                sh 'echo "Testing the application...""'
                sh 'pip install -r requirements.txt'
                sh 'python3 test_app.py'
            }
        }
        stage('Build') {
            echo '"Building the application..."'
            dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")

            withDockerRegistry([ credentialsId: "dockerhub-deflorioan", url: "" ]) {
            dockerImage.push("${IMAGE_NAME}:${IMAGE_TAG}")
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Deploying the application..."'
                sh "docker rm -f ${APP_NAME}"
                sh "docker run -dit --name ${APP_NAME} -p ${PORT} ${IMAGE_NAME}:${IMAGE_TAG}"   
            }
        }
 
    }
   post {
        success {
            echo "Build Success!"
        }
        failure {
            echo 'Build Failed!'
        }
        cleanup {
            echo "Clean up workspace"
            cleanWs()
        }
   }
}