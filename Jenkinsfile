pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: kubectl
            image: gcr.io/cloud-builders/kubectl
            command:
            - cat
            tty: true
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock
        '''
    }
  }
  stages {  
    stage('Build') {
      steps {
        nodejs(nodeJSInstallationName: 'nodejs') {
            sh 'npm install -g typescript'
        }
      }
    }
    stage('download') {
        steps {
            git 'https://github.com/2206-devops-batch/e-commerce-frontend-blue.git'
            //echo 'Finshed downloading git'
            //force stop docker and clean up images
            container('docker') {
                sh "docker system prune -af"
            }
        }
    }
    /*stage('Build') {
      steps {
        container('maven') {
          //sh 'mvn package'
        }
      }
    }*/
    /*stage('SonarCloud analysis') {
        steps {       
            script {
                nodejs(nodeJSInstallationName: 'nodejs'){             
                    def scannerHome = tool 'sonar scanner';             
                    withSonarQubeEnv('SonarCloud') { 
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
    }
    stage('Quality gate') {
        steps {
            script {
                timeout(time: 5, unit: 'MINUTES') {
                  waitForQualityGate abortPipeline: true
                }
            }
        }
    }*/
    stage('Docker Build & Push') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'password', usernameVariable: 'username')]) {
            sh 'docker version'
            sh 'docker build -t othom/e-commerce-frontend-blue:latest .'
            sh 'docker login -u ${username} -p ${password}'
            sh 'docker push othom/e-commerce-frontend-blue:latest'
            sh 'docker logout'
          }
        }
      }
    }    
    stage('Deploy Image to AWS EKS cluster') {
      steps {
        container('kubectl') {
               sh 'kubectl get pods --all-namespaces'
             //sh 'kubectl apply -f frontendbluedeployment.yaml'    
             //sh 'kubectl apply -f frontendblueservice.yaml'
         }
        container('docker') {
          //withKubeConfig([credentialsId: 'aws-cred']) {
            sh 'docker run --rm --name kubectl bitnami/kubectl:latest get pod'
            
          //}
        }       
      }
    }
    
  }
    /*post {
        always {
          container('docker') {
            sh 'docker logout'
          }
        }
    }*/
    
}
