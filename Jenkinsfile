def repoName = "tfe-demo"                         //Repo to store TF code for the TFE Workspace
def repoSshUrl = "git@github.com:wasanthag/tfe-demo.git"   //Must be ssh since we're using sshagent()
def tfCodeId = "example-${env.BUILD_NUMBER}"        //Unique name to use in the TF code filename and resource
def tfCodeFilePath = "${repoName}/${tfCodeId}.tf"   //Path and filename of the new TF code file
//Credentials
def gitCredentials = 'github-ssh'                   //Credential ID in Jenkins of your GitHub SSH Credentials
def tfeCredentials = 'tfe-token'                         //Credential ID in Jenkins of your Terraform Enterprise Credentials


 pipeline {
   agent any
   
   triggers {
    githubPush()
  }
      
  stages {
      
    stage('1. checkout') {
        steps {
          checkout([
                 $class: 'GitSCM',
                 branches: [[name: 'master']],
                 userRemoteConfigs: [[
                    url: 'git@github.com:wasanthag/tfe-demo',
                    credentialsId: 'github-ssh',
                 ]]
                ])
           }
    }  

   
    stage('2. Run the Workspace'){
      environment {
          REPO_NAME = "${repoName}"
      }
      steps {
       withCredentials([string(credentialsId: tfeCredentials, variable: 'TOKEN')]) {
          sh '''
            terraform init -backend-config="token=$TOKEN"  #Uses config.tf and the user API token to connect to TFE
            terraform apply
          '''
        }
      }
    }

    stage('3. Do integration or deployment testing'){
      steps {
        echo "Do integration or deployment testing ..."
        sleep 60
        sh '''
          sh check_webserver_status.sh
        '''
      }
    }

    stage('4. Cleanup (destroy) the test machine'){
      steps {
        withCredentials([string(credentialsId: tfeCredentials, variable: 'TOKEN')]) {
          sh """
             terraform init -backend-config="token=$TOKEN" 
             terraform destroy
            """
        }
        }
    }

  } //stages

  
}
