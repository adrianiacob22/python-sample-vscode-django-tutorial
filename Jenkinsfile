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
       stage('Build and test') {
           steps {
              echo 'Starting to build docker image'
              script {
                def appImage = docker.build(registry + "/python-django:$BUILD_ID")
              }
           }
       }
//       stage('Test') {
//           steps {
//               docker.image('mysql:5').withRun('-e "MYSQL_ROOT_PASSWORD=my-secret-pw" -p 3306:3306') { c ->
//               /* Wait until mysql service is up */
//               sh 'while ! mysqladmin ping -h0.0.0.0 --silent; do sleep 1; done'
//               /* Run some tests which require MySQL */
//               sh 'make check'
//              }
//           }
//       }
       stage('Publish') {
           steps{
               script {
                   docker.withRegistry( '', registryCredential ) {
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
