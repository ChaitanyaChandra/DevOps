def call() {
    pipeline {
        agent { label 'work_station'}
        options {
            disableConcurrentBuilds()
            ansiColor('xterm')
        }
        triggers {
            upstream(upstreamProjects: "terraform", threshold: hudson.model.Result.SUCCESS)
        }
        parameters {
            choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Pick Terraform Action')
        }
        stages
                {
                    stage('Label Builds')
                            {
                                steps {
                                    script {
                                        addShortText background: 'white', borderColor: 'white', color: 'red', link: '', text: "${ACTION}"
                                    }
                                }
                            }

                    stage ('terraform apply')
                            {
                                steps
                                        {
                                            git branch: 'main', credentialsId: 'Chaitanya', url: 'https://github.com/ChaitanyaChandra/terraform.git'
                                            dir('route53') {
                                                sh """
                                                    terraform init
                                                    terraform ${ACTION} -auto-approve
                                               """
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