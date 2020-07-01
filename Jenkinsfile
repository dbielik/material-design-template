pipeline {
    
    // execute on master node
    agent {
        label 'slave-node'
    }

    // pipeline parameters
    parameters {
        // Release type parameter
        choice (
            name: 'RELEASE',
            choices: ['DEVELOP', 'TEST', 'RELEASE'], 
            description: 'Release type selection (DEVELOP|TEST|RELEASE)')
        
        // Release version parameter
        string (
            name: 'RELEASE_VER', 
            defaultValue: '0.1.1', 
            description: 'Release version (number value, format x.x.x)', 
            trim: false)
    }

    // global tools
    tools {
        nodejs 'Node12'
    }

    // pipeline steps
    stages {
        // CHECKOUT git repository 
        stage('Checkout') {
            steps {
                git 'https://github.com/aurcame/mdt'
            }
        }

        // BUILD: clean .css files and minimize .js files
        stage('Build') {
            parallel {
                // minimize .js files 
                stage('JS') {
                    steps {
                        sh label: 'minimize JS', script: """
                        cd ${WORKSPACE}/www/js
                        uglifyjs --timings init.js -o ../min/custom-min.js
                        """
                    }
                }

                // clean .css files 
                stage('CSS') {
                    steps {
                        sh label: 'minimize CSS', script: """
                        cd ${WORKSPACE}/www/css
                        cleancss -d style.css > ../min/custom-min.css"""
                    }
                }

                // tar artifact
                stage('Tar artifact') {
                    steps {
                        sh label: 'archive', script: """
                        cd ${WORKSPACE}/www
                        tar --exclude='./css' --exclude='./js' -c -z -f ../site-archive-${params.RELEASE}-${params.RELEASE_VER}-${BUILD_NUMBER}.tgz ."""
                    }
                }
            }
        }

        // Archiving the project 
        stage('Archive') {
            when {
                expression {
                    params.RELEASE == 'RELEASE'
                }
            }
            steps {
                archiveArtifacts '*.tgz'
            }
        }
    }
}
