def img
pipeline {
    // setting up dockhub information needed to push image.
    environment {
        registry = "othom/e-commerce-frontend-blue"
        registrycredential = 'dockerhub'
        dockerimage = ''
    }
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
            image: bitnami/kubectl
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
        stage('SonarQube Analysis'){
            steps{
                nodejs(nodeJSInstallationName: 'nodejs'){
                    sh "npm install"
                    withSonarQubeEnv('SonarQube'){
                        sh "npm install -g typescript"
                        sh "npm install sonarqube-scanner --save -dev"
                        //do not uncomment this sh "npm install -g sonarqube-scanner"
                        sh "npm run sonar"
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
           }
        }  
        
        stage('Build Image') {
            steps {
                script{
                    //reference: https://www.jenkins.io/doc/book/pipeline/jenkinsfile/
                   img = registry + ":${env.BUILD_ID}"
                    //reference: https://docs.cloudbees.com/docs/admin-resources/latest/plugins/docker-workflow
                   dockerImage = docker.build("${img}")
                }
            }
        }

        stage('Push To DockerHub') {
            steps {
                script{
                    docker.withRegistry( 'https://registry.hub.docker.com ', registryCredential ) {
                        //push image to registry
                        dockerImage.push()
                    }
                }
           }
        }

    }

}
