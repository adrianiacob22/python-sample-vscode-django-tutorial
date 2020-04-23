pipeline {
   agent  {
      node {
            label 'docker'
      }
   }
   environment {
       registry = "nexus.local.net:8123"
       registryCredential = credentials('docker-repo')
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
                def appImage = docker.build(registry + "/python-django:$BUILD_ID")
              }
           }
       }
       stage('Test') {
           steps {
               script {
                 docker.image(registry + "/python-django:$BUILD_ID") { c ->
                   docker.image(registry + "/python-django:$BUILD_ID").inside("--link ${c.id}:app") {}
                   docker.image(curlimages/curl).inside("--link ${c.id}:app") {
                   sh 'curl -X GET -i -o /dev/null -s -w "%{http_code}\n" ${app}:8000'
                   }
                   
               }
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
