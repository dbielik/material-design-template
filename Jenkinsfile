pipeline {
    agent {
        label 'krut'
    }

    parameters {
        choice choices: ['DEVELOP', 'RELEASE'], description: '', name: 'RELEASE'
        string defaultValue: '0.0.1', description: '', name: 'RELEASE_VER', trim: false
    }

    tools {
        nodejs 'Node12'
    }

    stages {
        stage('Parallel') {
            parallel {
                stage('cleancss') {
                    steps {
                        sh label: 'minimize', script: """cd ${WORKSPACE}/www/css
                        cleancss -d style.css > ../min/custom-min.css """
                    }
                }
                stage('uglifyjs') {
                    steps {
                        sh label: 'minimize', script: """cd ${WORKSPACE}/www/js
                        uglifyjs --timings init.js -o ../min/custom-min.js"""
                    }
                }
            }
        }
        stage('build') {
            steps {
                sh label: 'minimize', script: """cd ${WORKSPACE}/www
                tar --exclude=\'./css\' --exclude=\'./js\' -c -z -f ../site-archive-${params.RELEASE}-${params.RELEASE_VER}-${params.BUILD_NUMBER}.tgz ."""
            }
        }
        stage('archive') {
            when {
                expression {
                    params.RELEASE == 'RELEASE'
                }
            }
            steps {
                archiveArtifacts "site-archive.tgz"
            }
        }
    }
}
