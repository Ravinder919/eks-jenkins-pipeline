# Purpose: This file is used to configure the backend for the terraform state file. 
# It sets up a remote backend that stores the state file in an S3 bucket.
terraform {
  backend "s3" {
    bucket = "neyo-capstone-remote-backend-4"
    region = "eu-west-3"
    key = "eks/terraform.tfstate"
  }
}



