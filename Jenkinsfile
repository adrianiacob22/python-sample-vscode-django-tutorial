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
                docker.withRegistry(registry, docker-repo) {
                def appImage = docker.build(registry + "/python-django:$BUILD_ID")
                }
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
   }
}
