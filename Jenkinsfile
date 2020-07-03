pipeline {
    
    // execute on master node
    agent {
        label 'slave-node'
    }
    
    environment {
        ENV_AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID_SECRET')
        ENV_AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY_SECRET')
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
        stage('CreateVM') {
            when {
                expression {
                    params.RELEASE_TYPE == 'RELEASE'
                    params.RELEASE_TYPE == 'RELEASE'
                }
            }
            steps {
                sh label: 'set_credentials', script: """
                    export AWS_ACCESS_KEY_ID=${ENV_AWS_ACCESS_KEY_ID}
                    export AWS_SECRET_ACCESS_KEY=${ENV_AWS_SECRET_ACCESS_KEY}
                    export AWS_DEFAULT_REGION=eu-central-1
                """

                //create ec aws cli
                sh label: 'startup_VM', script: """
                    cd ${WORKSPACE}
                    aws ec2 run-instances \
                    --region eu-central-1 \
                    --image-id ami-0a02ee601d742e89f \
                    --count 1 \
                    --instance-type t2.micro \
                    --key-name awskey-frankfurt\
                    --security-group-ids sg-01e9711790fdb054c sg-0abfebc8260645bb6 \
                    --subnet-id subnet-0fcbecf97e53d86c2 \
                    --user-data file://user-data.txt
                """
            }
        }

    }
}
