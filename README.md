# terraform_EC2

This repo contains code for deploying an EC2 instance using Terraform and then using ansible to configure the deployed EC2 instance with a docker based application.

As part of the Terraform code we are:
- Configuring AWS access key and secret access key as variables
- Using an AMI instance to create an EC2 instance
- Transferring public key to the EC2 instance
- Configure VPC and its parameters
- Assign security group to the EC2 instance

Use Terraform init, plan and deploy to run the code. 

Make changes to the roles.yml file to link the ansible role and execute the application code.

