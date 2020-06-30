pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/naturkach/mdt'
            }
        }
        stage('Build') {
            steps {
 	               sh "scp -r ${WORKSPACE}/www/* root@prod.server:/var/www/html"
                  }
                }
        stage('Archive') {
            steps {
                    sh label: 'archive', script: """
                        cd ${WORKSPACE}/www
                        tar  -c -z -f  ../site-archive-${params.RELEASE}-${params.RELEASE_VER}-${BUILD_NUMBER}.tgz ."""
                        archiveArtifacts '*.tgz'
                    }
        }
            
    }
}
