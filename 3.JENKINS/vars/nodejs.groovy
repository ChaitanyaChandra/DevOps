def call() {
  env.APPTYPE = "nodejs"
  node {
    // try {
      for(e in env){
        echo e + " is " + ${e}
      }
      common.codeCheckout()
      common.codeQuality()
      common.codeChecks()
      common.artifacts()
    // } catch (Exception e) {
    //   mail bcc: '', body: "Build Failed ${RUN_DISPLAY_URL}", cc: '', from: 'email@chaitu.net', replyTo: '', subject: 'BUILD FAILURE', to: 'majorchowdary@gmail.com'
    // }

  }


}