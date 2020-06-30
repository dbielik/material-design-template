node{
    stage ('Checkout') {
        git poll: false, url: 'https://github.com/naturkach/mdt'
    }
        
    stage('Build') {
                sh "scp -r ${WORKSPACE}/www/* root@prod.server:/var/www/html"
    }
    stage('Archive') {
                    archiveArtifacts artifacts: '**'
    }
}
