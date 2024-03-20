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
                    def commitHash = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    def commitAuthor = sh(script: "git log -1 --pretty=format:'%an <%ae>'", returnStdout: true).trim()
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    mattermostSend color: 'good', message: "[Backend] SUCCESS: ${commitHash}\n ${commitMessage}\n by ${commitAuthor}", webhookUrl: "${WEBHOOK_URL}"
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
                    mattermostSend color: 'danger', message: "[Backend] FAILURE: ${commitHash}\n ${commitMessage}\n by ${commitAuthor}", webhookUrl: "${WEBHOOK_URL}"
                }
            }
        }
    }
}
