pipeline {
    agent any
    environment {
        TF_CLI_ARGS = '-no-color'
    }
    tools {
        terraform 'terraform'
    }
    stages {
        stage('Determine Build Type') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        BUILD_TYPE = 'deploy'
                    } 
                    else if (env.BRANCH_NAME == 'destroy') {
                        BUILD_TYPE = 'destroy'
                    }
                    else {
                        BUILD_TYPE = 'integrate'
                    }
                }
            }
        }
        stage('Terraform Commands') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'peja-master-infra-user', 
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    script {
                        if (BUILD_TYPE != 'destroy') {
                            sh 'cd infrastructure-eu'
                            sh 'terraform init -input=false'
                            sh 'terraform plan'

                            sh 'cd ../infrastructure-us'
                            sh 'terraform init -input=false'
                            sh 'terraform plan'
                            sh 'cd ..'

                            if (BUILD_TYPE == 'deploy') {
                                sh 'cd infrastructure-eu'
                                sh 'terraform apply --auto-approve'
                                sh 'cd ../infrastructure-us'
                                sh 'terraform apply --auto-approve'
                                sh 'cd ..'
                            }
                        }
                        else {
                            sh 'cd infrastructure-eu'
                            sh 'terraform destroy --auto-approve'
                            sh 'cd ../infrastructure-us'
                            sh 'terraform destroy --auto-approve'
                            sh 'cd ..'
                        }
                    }
                }
            }
        }
    }
}