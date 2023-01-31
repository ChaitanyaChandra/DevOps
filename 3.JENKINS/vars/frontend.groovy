def call() {
    pipeline {
        agent { label 'work_station'}
        options {
            disableConcurrentBuilds()
            ansiColor('xterm')
        }
        environment {
            CREDS = credentials('APP_CREDS')
        }
//        triggers {
//            pollSCM('H/2 * * * *')
//        }
        stages
                {
                    stage('Label Builds')
                            {
                                steps {
                                    script {
                                        env.gitTag = GIT_BRANCH.split('/').last()
                                        addShortText background: 'white', borderColor: 'white', color: 'red', link: '', text: "${gitTag}"
                                    }
                                }
                            }

                    stage ('compile the code')
                            {
                                steps
                                        {
                                            sh 'echo compile code'
                                            git branch: 'main', url: 'https://github.com/ChaitanyaChandra/DevOps.git'
                                            dir('frontend') {
                                            }
                                        }
                            }

                    stage ('Publish artifacts')
                            {
                                when {
                                    expression { sh([returnStdout: true, script: 'echo ${GIT_BRANCH} | grep tags || true' ]) }
                                }
                                steps
                                        {
                                            script{
                                                common.prepare_artifacts("frontend")
                                                common.publish_artifacts(CREDS_USR, CREDS_PSW, "nexus-dev.chaitu.org", "nginx", "frontend")
                                            }
                                        }
                            }
                    stage('Publish AMI') {
                        when {
                            expression { sh([returnStdout: true, script: 'echo ${GIT_BRANCH} | grep tags || true' ]) }
                        }
                        steps {
                            script {
                                common.make_AMI(CREDS_USR, CREDS_PSW, "nginx", "frontend", "dev")
                            }
                        }
                    }
                }
        post {
            always {
                cleanWs()
            }
        }
    }
}