pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID         = "815405031071"
        AWS_DEFAULT_REGION     = "eu-central-1"
        NGINX_IMAGE_REPO_NAME  = "my-nginx"
        APACHE_IMAGE_REPO_NAME = "my-apache"
        IMAGE_TAG              = "v${BUILD_NUMBER}"
        NGINX_REPOSITORY_URI   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${NGINX_IMAGE_REPO_NAME}"
        APACHE_REPOSITORY_URI  = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${APACHE_IMAGE_REPO_NAME}"
    }
   
    stages {
        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/suhlob/demo.git']]])
            }
        }
  
        // Building Docker images
        stage('Building image') {
            steps {
                script {
                    nginxDockerImage = docker.build("${NGINX_IMAGE_REPO_NAME}:${IMAGE_TAG}", "./data/nginx")
                    apacheDockerImage = docker.build("${APACHE_IMAGE_REPO_NAME}:${IMAGE_TAG}", "./data/apache")
                }
            }
        }
   
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps {
                script {
                    sh "docker tag ${NGINX_IMAGE_REPO_NAME}:${IMAGE_TAG} ${NGINX_REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker tag ${APACHE_IMAGE_REPO_NAME}:${IMAGE_TAG} ${APACHE_REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${NGINX_IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${APACHE_IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Run containers on remote instances') {
            steps {
                sshagent(['dev-server']) {
                    sh '''ssh -t -t ubuntu@52.29.189.136 -o StrictHostKeyChecking=no docker stop my-nginx:latest || true && 
                        docker stop my-apache:latest || true && 
                        docker rm my-nginx:latest || true && 
                        docker rm my-apache:latest || true &&
                        docker rmi my-nginx:latest || true && 
                        docker rmi my-apache:latest || true &&
                        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com &&
                        docker pull ${NGINX_REPOSITORY_URI}:${IMAGE_TAG} &&
                        docker pull ${APACHE_REPOSITORY_URI}:${IMAGE_TAG} &&
                        docker tag ${NGINX_REPOSITORY_URI}:${IMAGE_TAG} my-nginx:latest &&
                        docker tag ${APACHE_REPOSITORY_URI}:${IMAGE_TAG} my-apache:latest &&
                        docker run -p 8081:80 -d --rm --network demo --name my-apache my-apache:latest && 
                        docker run -p 80:80 -p 443:443 -d --rm --network demo --name my-nginx my-nginx:latest
                    '''
                }
            }
        }
    }
}