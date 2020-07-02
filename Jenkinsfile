pipeline{
    
    agent{label "linux"}
    stages{
        stage('checkout'){
            steps{
                git 'https://github.com/Hermesss/mdt.git'
            }
        }
        
        stage('minify, archive website & save artifact'){
            tools {nodejs "NodeJS14"}
            //when{
            //    branch 'master'
            //}
            steps {
                echo 'run this stage - ony if the branch = master branch'
                sh ''' npm install -g uglify-js npm install clean-css-cli -g '''
                sh ''' cd ./www/js
                       uglifyjs init.js -o init.min.js
                       cd ../css
                       cleancss -o style.min.css style.css
                       cd ../..
                       echo $PWD
                       tar -czvf www.tar.gz www
                   '''
                archiveArtifacts artifacts: 'www.tar.gz', followSymlinks: false
                   }
        }
        stage (' PR CSS Stylecheck ') {
        //when {
        //        branch 'PR-*'  
        //    }

            steps {
            sh '''
            echo "PULL REQUEST, Applying Stylelint"
            npm install stylelint --save-dev
            npm install stylelint-config-standard --save-dev
            echo '{
  "extends": "stylelint-config-standard"
}' > .styleintrc.json
            npx stylelint --config .styleintrc.json "**/*.css" -o report-stylelint.txt || true
               '''
            archiveArtifacts artifacts: 'report-stylelint.txt', followSymlinks: false
            }

        }
        
    }
}