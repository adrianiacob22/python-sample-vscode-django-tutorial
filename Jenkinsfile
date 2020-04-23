pipeline {
   agent  {
      node {
            label 'docker'
      }
   }
   environment {
       registry = "nexus.local.net:8123"
   }
   stages {
       stage('Checkout scm') {
           steps {
               checkout scm
           }
       }
       stage('Build and test') {
           steps {
              echo 'Starting to build docker image'
              script {
               def appImage = docker.build registry + ":$BUILD_NUMBER"
              }
           }
       }

       stage('Publish') {
           environment {
               registryCredential = 'docker-repo'
           }
           steps{
               script {
                   docker.withRegistry( '', registryCredential ) {
                       appImage.push()
                       appImage.push('latest')
                   }
               }
           }
       }
       /*stage ('Deploy') {
           steps {
               script{
                   def image_id = registry + ":$BUILD_NUMBER"
                   sh "ansible-playbook  playbook.yml --extra-vars \"image_id=${image_id}\""
               }
           }
       }*/
   }
}
