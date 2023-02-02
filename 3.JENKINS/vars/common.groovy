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
        # sh "sonar-scanner -Dsonar.projectKey=${PROJECT} -Dsonar.sources=. -Dsonar.host.url=https://sonar.chaitu.net -Dsonar.login=${USER} -Dsonar.password=${PASSWORD}"
        # sh "sonar-quality-gate.sh ${USER} ${PASSWORD} ${URL} ${PROJECT}"
       sonar-scanner -Dsonar.host.url=http://sonar.chaitu.net:9000 -Dsonar.login=${sonarUser} -Dsonar.password=${sonarPass} -Dsonar.projectKey=${COMPONENT} -Dsonar.qualitygate.wait=true
        # echo OK
      '''
    }
  }
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

      if (env.APPTYPE == "nginx") {
        sh '''
          #cd static
          zip -r ../${COMPONENT}-${TAG_NAME}.zip *
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
         curl -v -u ${nexusUser}:${nexusPass} --upload-file ${COMPONENT}-${TAG_NAME}.zip http://nexus.roboshop.internal:8081/repository/${COMPONENT}/${COMPONENT}-${TAG_NAME}.zip
       '''
     }
   }

  }

 }

}