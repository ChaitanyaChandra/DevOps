def call() {
    pipeline {
        agent {
            label "${BUILD_LABEL}"
        }

        //environment {}

        options {
            ansiColor('xterm')
        }

        parameters {
            choice(name: 'ENVIRONMENT', choices: ['', 'dev', 'prod'], description: 'Pick Environment')
            choice(name: 'ACTION', choices: ['', 'apply', 'destroy'], description: 'Pick Terraform Action')
        }

        stages {

            stage('Label Builds') {
                steps {
                    script {
                        addShortText background: 'white', borderColor: 'white', color: 'red', link: '', text: "${ENVIRONMENT}"
                        addShortText background: 'white', borderColor: 'white', color: 'red', link: '', text: "${ACTION}"
                    }
                }
            }

            stage('Apply Terraform Action') {
                steps {
                    sh '''
            terraform init -backend-config=env/${ENVIRONMENT}-backend.tfvars
            terraform ${ACTION} -auto-approve -var-file=env/${ENVIRONMENT}.tfvars
          '''
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
