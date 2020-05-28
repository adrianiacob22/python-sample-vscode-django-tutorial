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
   }
   stages {
       stage('Checkout scm') {
           steps {
               cleanWs()
               checkout scm
           }
       }
       stage('Build') {
           steps {
              echo 'Starting to build docker image'
              script {
                env.appImage = docker.build(registry + "/python-django:$BUILD_ID")
              }
           }
       }
       stage('Integration test') {
           steps {
               script {
                  sh '''
                  cd test
                  set -a
                  docker-compose -p ci build
                  docker-compose config
                  docker-compose -p ci up -e "appImage=${appImage}" --abort-on-container-exit --exit-code-from curl
                  docker-compose -p ci rm -f
                  '''
              }
           }
       }
       stage('Publish') {
           steps{
               script {
                   docker.withRegistry( registryurl, 'nexus' ) {
                      appImage.push()
                      appImage.push('latest')
                   }
               }
           }
       }
       stage ('Deploy') {
           steps {
               script{
//                   sh "ansible-playbook  playbook.yml --extra-vars \"appImage=${image_id}\""
                      withCredentials([kubeconfigFile(credentialsId: 'k8smaster', variable: 'KUBECONFIG')]){
                        ansiColor('xterm') {
                          ansiblePlaybook (
                          colorized: true,
                          playbook: 'deploy/playbook.yml',
                          extras: "-e \"appImage=${appImage}\" -vv")
                        }
                      }
               }
           }
       }
   }
}
