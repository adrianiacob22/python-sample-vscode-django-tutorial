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
               docker.image(appImage).withRun(-p 8000:8000') { c ->
               /* Wait until the application is started */
               sh 'sleep 10'
               /* Run some tests which require the app running */
               sh '''errcode=$(curl -X GET -i -o /dev/null -s -w "%{http_code}\n" "http://localhost:8000/")
               if [[ ${errcode} == 0 ]]; then
               echo "Test succeeded"
               else
               echo "Test failed. Check app status."
               fi
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
