pipeline {
    agent any
    
    stages {
        stage('Example') {
            steps {
                echo 'An example build step.'
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
                    def commitAuthor = sh(script: "git log -1 --pretty=format:'%an <%ae>'", returnStdout: true).trim()
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    mattermostSend color: 'good', message: "[Backend] SUCCESS - [${env.BUILD_NUMBER}]\n : ${commitMessage}\n by ${commitAuthor}", webhookUrl: "${WEBHOOK_URL}"
                }
            }
        }
        failure {
            withCredentials([
                string(credentialsId: 'webhook_url', variable: 'WEBHOOK_URL'),
                string(credentialsId: 'channel', variable: 'CHANNEL')
                ]) {
                script {
                    def commitAuthor = sh(script: "git log -1 --pretty=format:'%an <%ae>'", returnStdout: true).trim()
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    mattermostSend color: 'good', message: "[Backend] FAILURE - [${env.BUILD_NUMBER}]\n : ${commitMessage}\n by ${commitAuthor}", webhookUrl: "${WEBHOOK_URL}"
            }
        }
    }
  
}
