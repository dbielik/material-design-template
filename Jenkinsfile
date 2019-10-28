pipeline {

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
                tar --exclude=\'./css\' --exclude=\'./js\' -c -z -f ../site-archive.tgz ."""
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
        stage('upload') {
            when {
                expression {
                    params.RELEASE == 'RELEASE'
                }
            }
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'site-archive', classifier: '', file: 'site-archive.tgz', type: 'tgz']], credentialsId: 'jenkins-demo', groupId: 'jenkins', nexusUrl: 'master.jenkins-practice.tk:9443', nexusVersion: 'nexus3', protocol: 'https', repository: 'vadymRepo', version: '${RELEASE_VERSION}'
            }
        }
    }
}
