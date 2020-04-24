pipeline {
   agent  {
      node {
            label 'docker'
      }
   }
   environment {
       registry = "nexus.local.net:8123"
       registryurl = "http://nexus.local.net:8123"
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
                sh 'echo "appImage=${registry}/python-django:$BUILD_ID" > test/env.sh'
              }
           }
       }
       stage('Integration test') {
           steps {
               script {
               println appImage
                  sh '''
                  cd test
                  set -a
                  . ./env.sh
                  docker-compose -p ci build
                  docker-compose -p ci up --abort-on-container-exit --exit-code-from curl
                  docker-compose -p ci rm -f
                  '''
              }
           }
       }
       stage('Publish') {
           steps{
               script {
                   docker.withRegistry( registryurl, 'nexus' ) {
                   println appImage
                      def appImage.push()
                      def appImage.push('latest')
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
