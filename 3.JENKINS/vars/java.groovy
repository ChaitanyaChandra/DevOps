def call() {
  env.SONAR_EXTRA_OPTS = "-Dsonar.java.binaries=./target"
  env.APPTYPE = "java"
  node {
    try {
      common.codeCheckout()
      stage('Compile Code') {
        sh 'mvn compile'
        sh 'pwd'
      }
      //common.codeQuality()
      // common.codeChecks()
      // common.artifacts()
    } catch (Exception e) {
      mail bcc: '', body: "Build Failed ${RUN_DISPLAY_URL}", cc: '', from: 'raghuk.vit@gmail.com', replyTo: '', subject: 'BUILD FAILURE', to: 'raghuk.vit@gmail.com'
    }

  }

}