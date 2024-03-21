pipeline {
    agent any

    environment {
        DOCKER_TAG = 'latest'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare application.yml') {
            steps {
                withCredentials([file(credentialsId: 'application_yml', variable: 'APPLICATION_YML')]){
                    script {
                        sh 'cp $APPLICATION_YML backend/src/main/resources/'
                    }
                }
            }
        }

        stage('Build with Gradle') {
            steps {
                dir('backend') {
                    sh 'chmod +x ./gradlew'
                    sh './gradlew build'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'docker_username', variable: 'DOCKER_USERNAME')]){
                    script {
                        sh 'docker build -t ${DOCKER_USERNAME}/pickachu:${DOCKER_TAG} -f backend/Dockerfile .'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: docker_id, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh 'echo $DOCKERHUB_PASS | docker login --username $DOCKERHUB_USER --password-stdin'
                    sh "docker push ${DOCKER_USERNAME}/pickachu:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to EC2'){
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: ec2_key, keyFileVariable: 'EC2_KEY')]) {
                    sh "ssh -i $EC2_KEY -o StrictHostKeyChecking=no ubuntu@13.124.88.19 'docker pull ${DOCKER_USERNAME}/pickachu:${DOCKER_TAG} && docker stop spring-app || true && docker rm spring-app || true && docker run --name spring-app -d -p 8080:8080 ${DOCKER_USERNAME}/pickachu:${DOCKER_TAG}'"
                }
            }
        }
    }

    post {
        success {
            withCredentials([
                string(credentialsId: 'webhook_url', variable: 'WEBHOOK_URL'),
                string(credentialsId: 'channel', variable: 'CHANNEL')
                ]) {
                script {
                    def commitHash = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    def commitAuthor = sh(script: "git log -1 --pretty=format:'%an <%ae>'", returnStdout: true).trim()
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    mattermostSend color: 'good', message: "[Backend] SUCCESS - ${commitHash}\n ${commitMessage}\n by ${commitAuthor}", webhookUrl: "${WEBHOOK_URL}"
                }
            }
        }
        failure {
            withCredentials([
                string(credentialsId: 'webhook_url', variable: 'WEBHOOK_URL'),
                string(credentialsId: 'channel', variable: 'CHANNEL')
                ]) {
                script {
                    def commitHash = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    def commitAuthor = sh(script: "git log -1 --pretty=format:'%an <%ae>'", returnStdout: true).trim()
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    mattermostSend color: 'danger', message: "[Backend] FAILURE - ${commitHash}\n ${commitMessage}\n by ${commitAuthor}", webhookUrl: "${WEBHOOK_URL}"
                }
            }
        }
    }
}
