pipeline {
    
    // execute on master node
    agent {
        label 'slave-node'
    }

    // pipeline parameters
    parameters {
        // Release type parameter
        choice (
            name: 'RELEASE_TYPE',
            choices: ['DEVELOP', 'TEST', 'RELEASE'], 
            description: 'Release type selection (DEVELOP|TEST|RELEASE)')
        
        // Release version parameter
        string (
            name: 'RELEASE_VER', 
            defaultValue: '0.1.1', 
            description: 'Release version (number value, format x.x.x)', 
            trim: false)
    }
    
    options {
        buildDiscarder(logRotator(artifactNumToKeepStr: '3', artifactDaysToKeepStr: '5', daysToKeepStr: '5', numToKeepStr: '3'))
        timeout(time: 1, unit: 'HOURS')
        timestamps()
        // ansiColor('xterm')
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

                // lint .css files
                stage('TEST') {
                    when {
                        allOf {
                            branch 'master'
                            expression {
                                params.RELEASE_TYPE == 'TEST'
                            }

                        }
                }

                    steps {
                        sh label: 'lint CSS', script: """
                        cd ${WORKSPACE}/www/css
                        stylelint style.css"""
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
                        tar --exclude='./css' --exclude='./js' -c -z -f ../site-archive-${params.RELEASE_TYPE}-${params.RELEASE_VER}-${BUILD_NUMBER}.tgz ."""
                    }
                }
            }
        }

        // Archiving the project 
        stage('Archive') {
            when {
                expression {

                    params.RELEASE_TYPE == 'RELEASE'
                }
            }
            steps {
                archiveArtifacts '*.tgz'
            }
        }

        // Deployment
        stage('Deploymnet') {
            when {
                expression {

                    params.RELEASE_TYPE == 'RELEASE'
                }
            }
            steps {
                sh label: 'set_credentials', script: """
                    echo "[default]" > ~/.aws/credentials 
                    echo "aws_access_key_id = ${credentials('AWS_ACCESS_KEY_ID')}" >> ~/.aws/credentials 
                    echo "aws_secret_access_key = ${credentials('AWS_SECRET_ACCESS_KEY')}" >> ~/.aws/credentials 
                    printf "[default]
                    region = eu-central-1
                    output = json" > ~/.aws/config

                """
            }
        }

    }
}
