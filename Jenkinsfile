pipeline{
    agent{
        label "linux"
    }
    stages{
        stage('minify'){
            agent any
            when{
                branch 'master'
            }
            steps {
                echo 'run this stage - ony if the branch = master branch'
                }
            }
        stage("Slylelint"){
            agent any
            steps{
                echo "====++++executing Slylelint++++===="
            }
            
            }
        stage('Archive'){
            agent any
            when{
                branch 'master'
            }
            steps {
                echo 'ARCHIVE run this stage - ony if the branch = master branch'
                }
            }
        }
    }