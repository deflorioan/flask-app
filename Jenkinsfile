pipeline {
    agent any
    environment {
        APP_NAME    = "flask-application"
        PORT        = "5000:5000"
        IMAGE_NAME  = "deflorioan/flask-app"
        IMAGE_TAG   = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        CREDS       = credentials('dockerhub-deflorioan')
    }
    
    stages {
        stage('Testing') {
            steps{
                sh 'echo "Testing the application..."'
                sh 'pip install -r requirements.txt'
                sh 'python3 test_app.py'
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Building the application..."'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh 'echo $CREDS_PSW | docker login -u $CREDS_USR --password-stdin'
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
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