pipeline {
    agent any

    environment {
        DOCKER_REPOSITORY = credentials('repository')
        DOCKER_TAG = '0.0.1'
    }
    

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare application.yml') {
            steps {
                withCredentials([file(credentialsId: 'application_yml', variable: 'APPLICATION_YML'), file(credentialsId: 'card_list', variable: 'CARD_LIST')]){
                    script {
                        sh 'cp $APPLICATION_YML backend/src/main/resources/'
                        sh 'mkdir -p backend/src/main/resources/static/images/'
                        sh 'cp $CARD_LIST backend/src/main/resources/static/images/'
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
                script {
                    sh 'docker build -t ${DOCKER_REPOSITORY}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_id', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                    sh 'docker push ${DOCKER_REPOSITORY}:${DOCKER_TAG}'
                }
            }
        }

        stage('Deploy to EC2'){
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_key', keyFileVariable: 'EC2_KEY'), usernamePassword(credentialsId: 'docker_id', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh '''
                    ssh -i $EC2_KEY -o StrictHostKeyChecking=no ubuntu@j10d110.p.ssafy.io "
                    echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin;
                    docker pull ${DOCKER_REPOSITORY}:${DOCKER_TAG};
                    docker stop spring-app || true;
                    docker rm spring-app || true;
                    docker run --name spring-app --net backend-network -d -p 8080:8080 ${DOCKER_REPOSITORY}:${DOCKER_TAG}"
                    '''
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
