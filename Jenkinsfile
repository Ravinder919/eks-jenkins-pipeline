#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-3"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "rm -rf .terraform .terraform.lock.hcl"
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        // Set AWS CLI credentials
                        sh "aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}"
                        sh "aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}"

                        // Set KUBECONFIG environment variable
                        sh "export KUBECONFIG=/var/lib/jenkins/.kube/config"

                        // Run kubectl apply
                        sh "aws eks update-kubeconfig --name myapp-eks-cluster" 
                        sh "kubectl apply -f nginx-deployment-service.yaml"
                        // Uncomment the line below if needed
                        // sh "kubectl apply -f complete-demo.yaml"
                    }
                }
            }
        }
    }
}



// "aws eks --region eu-west-2 update-kubeconfig --name myapp-eks-cluster --profile kbneyo55"


//  The Jenkinsfile is a Groovy script that defines the pipeline. It is divided into stages, and each stage contains steps. The pipeline is executed on an agent, which is a Jenkins node. The  environment  block is used to define environment variables that are used in the pipeline. 
//  The first stage is to create an EKS cluster using Terraform. The second stage is to deploy the application to the EKS cluster. 
//  The  script  block is used to execute shell commands. The  dir  block is used to change the working directory. 
//  The  credentials  function is used to retrieve the AWS credentials from Jenkins. 
//  The  sh  function is used to execute shell commands. 
//  The  aws eks update-kubeconfig  command is used to update the kubeconfig file with the EKS cluster details. 
//  The  kubectl apply  command is used to apply the Kubernetes manifests. 
//  The  complete-demo.yaml  file is commented out. You can uncomment it if you want to deploy the complete demo application. 
//  Step 5: Create a Jenkins pipeline 
//  Now that we have the Jenkinsfile, we can create a Jenkins pipeline. 
//  Go to the Jenkins dashboard and click on  New Item . 
//  Enter a name for the pipeline and select  Pipeline . Click  OK . 
//  Scroll down to the  Pipeline  section and select  Pipeline script from SCM . 
//  Select  Git  as the SCM and enter the repository URL. 
//  Click  Save . 
//  Step 6: Run the Jenkins pipeline 
//  Now that we have created the Jenkins pipeline, we can run it. 
//  Click on  Build Now  to run the pipeline. 
//  The pipeline will start running. 
//  The pipeline will create an EKS cluster using Terraform and deploy the application to the EKS cluster. 
//  Once the pipeline has finished running, you can access the application using the load balancer URL. 
//  Conclusion 
//  You have learned how to deploy an application to an EKS cluster using Jenkins. 
//  You have created a Jenkins pipeline that creates an EKS cluster using Terraform and deploys the application to the EKS cluster. 
//  You can use this pipeline to deploy any application to an EKS cluster. 
//  Thanks for reading! 
//  If you have any questions or comments, feel free to leave them below. 
//  Happy coding! 
//  Peer Review Contributions by:  Lalithnarayan C
