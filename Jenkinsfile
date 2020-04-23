pipeline {
   agent  {
      node {
            label 'docker'
      }
   }
   environment {
       registry = "nexus.local.net:8123"
       registryCredential = credentials('docker-repo')
       appImage = "NOT_SET"
   }
   stages {
       stage('Checkout scm') {
           steps {
               checkout scm
           }
       }
       stage('Build') {
           steps {
              echo 'Starting to build docker image'
              script {
                def dImage = docker.build(registry + "/python-django:$BUILD_ID")
                env.appImage = dImage
                sh 'echo "appImage=$appImage" > test/env.sh'
              }
           }
       }
       stage('Test') {
           steps {
               script {
                  sh '''
                  cd test
                  set -a
                  source env.sh
                  docker-compose -p ci build
                  docker-compose -p ci up --abort-on-container-exit

                  '''
              }
           }
       }
       stage('Publish') {
           steps{
               script {
                   docker.withRegistry( registry, registryCredential ) {
                       appImage.push()
                       appImage.push('latest')
                   }
               }
           }
       }
//       stage ('Deploy') {
//           steps {
//               script{
//                   def image_id = registry + ":$BUILD_NUMBER"
//                   sh "ansible-playbook  playbook.yml --extra-vars \"image_id=${image_id}\""
//               }
//           }
//       }
   }
}
