def codeCheckout() {
  stage('Code Checkout') {
    sh 'find . | sed 1d |xargs rm -rf'
    git branch: 'main', url: "https://github.com/chaitanyachandra/${COMPONENT}.git"
  }
}

def codeQuality() {
  stage('Code Quality') {
    withCredentials([usernamePassword(credentialsId: 'APP_CREDS', passwordVariable: 'sonarPass', usernameVariable: 'sonarUser')]) {
      sh '''
       echo "codequality"
       sonar-scanner -Dsonar.host.url=http://sonar.chaitu.net:9000 -Dsonar.login=${sonarUser} -Dsonar.password=${sonarPass} -Dsonar.projectKey=${COMPONENT} -Dsonar.qualitygate.wait=true ${SONAR_EXTRA_OPTS}
      '''
    }
  }

  // if ( env.BRANCH_NAME != "main" || env.TAG_NAME != ".*" ) {
  //   stage('merge TO main') {
  //   withCredentials([usernamePassword(credentialsId: 'GIT_CREDS', passwordVariable: 'gitPass', usernameVariable: 'gitUser')]){
  //   sh """
  //   # git remote add origin https://${gitUser}:${gitPass}@github.com/chaitanyachandra/${COMPONENT}.git

  //   git remote set-url origin https://${gitUser}:${gitPass}@github.com/chaitanyachandra/${COMPONENT}.git

  //   # for PR
  //   # git request-pull origin/main ${env.BRANCH_NAME}

  //   git checkout main
    
  //   # Fetch the latest changes from the remote repository
  //   git fetch origin

  //   # Merge the changes from the feature branch
  //   git merge origin/${env.BRANCH_NAME}

  //   # Push the merged changes back to the remote repository
  //   git push origin main
  //   """     
  //     }
  //   }
  // }

  // if ( env.BRANCH_NAME != "main" || env.BRANCH_NAME != "dev" || env.TAG_NAME != ".*") {
  //   stage('Delete branch') {
  //   withCredentials([usernamePassword(credentialsId: 'GIT_CREDS', passwordVariable: 'gitPass', usernameVariable: 'gitUser')]){
  //   sh """
  //   git remote set-url origin https://${gitUser}:${gitPass}@github.com/chaitanyachandra/${COMPONENT}.git
  //   # delete branch locally
  //   # git branch -d ${env.BRANCH_NAME}

  //   # delete branch remotely
  //   git push origin --delete ${env.BRANCH_NAME}
  //   """
  //     }
  //   }
  // }

}

def codeChecks() {
  if ( env.BRANCH_NAME == "main" || env.TAG_NAME ==~ ".*" ) {

    stage('Style & Lint Checks') {
      echo 'Style Checks'
    }

    stage('Unit Tests') {
      echo 'Unit Tests'
    }

  }
}

def artifacts() {
  if ( env.TAG_NAME ==~ ".*" ) {

    stage('Prepare Artifacts') {
      if (env.APPTYPE == "nodejs") {
        sh '''
          npm install 
          zip -r ${COMPONENT}-${TAG_NAME}.zip node_modules index.js 
        '''
      }


      if (env.APPTYPE == "java") {
        sh '''
          mvn clean package 
          mv target/status-1.0-SNAPSHOT.jar ${COMPONENT}.jar 
          zip -r ${COMPONENT}-${TAG_NAME}.zip ${COMPONENT}.jar
        '''
      }      
    }

    // stage('Build Docker Image') {
    //   sh '''
    //     docker build -t 633788536644.dkr.ecr.us-east-1.amazonaws.com/${COMPONENT}:latest .
    //   '''
    // }

  if ( env.TAG_NAME ==~ ".*" ) {

    // stage('Publish Docker Image') {
    //   sh '''
    //     aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 633788536644.dkr.ecr.us-east-1.amazonaws.com
    //     docker tag 633788536644.dkr.ecr.us-east-1.amazonaws.com/${COMPONENT}:latest 633788536644.dkr.ecr.us-east-1.amazonaws.com/${COMPONENT}:${TAG_NAME}
    //     docker push 633788536644.dkr.ecr.us-east-1.amazonaws.com/${COMPONENT}:${TAG_NAME}
    //   '''
    // }

   stage('Publish Artifacts') {
     withCredentials([usernamePassword(credentialsId: 'APP_CREDS', passwordVariable: 'nexusPass', usernameVariable: 'nexusUser')]) {
       sh '''
         curl -v -u ${nexusUser}:${nexusPass} --upload-file ${COMPONENT}-${TAG_NAME}.zip http://nexus.chaitu.net:8081/repository/${COMPONENT}/${COMPONENT}-${TAG_NAME}.zip
       '''
     }
   }

  }

 }

}