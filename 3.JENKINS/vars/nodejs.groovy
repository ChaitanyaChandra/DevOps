def call() {
  env.APPTYPE = "nodejs"
  node (env.RUNNER){
    try {
      common.codeCheckout()
      common.codeQuality()
      common.codeChecks()
      common.artifacts()
      cleanWs()
    } catch (Exception e) {
      mail bcc: '', body: "Build Failed ${RUN_DISPLAY_URL}", cc: '', from: 'email@chaitu.net', replyTo: '', subject: 'BUILD FAILURE', to: 'majorchowdary@gmail.com'
    }

  }


}