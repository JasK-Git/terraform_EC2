variable "aws_region" {
    description = "AWS region"
    type = string
    default = ""
}

variable "access-key" {
    description = "Access key for logging into AWS account"
    type = string
    default = "" 
}

variable "secret-access-key" {
    description = "Secret access key for logging into AWS account"
    type = string
    default = ""
}

variable "ami_owner" {
    description = "owner ID of the AMI image"
    type = list(string)
    default = [""]
}

variable "instance-type" {
    description = "specify the instance type"
    type = string
    default = ""
}

variable "ssh-public-key" {
    description = "Public key for accessing EC2 instance"
    type = string
    default = "~/.ssh/id_rsa.pub" #enter ssh key file name relative to ansible master
}

variable "vpv_cidr_block" {
    description = "CIDR block for VPC"
    type = string
    default = "192.168.0.0/20"
}

variable "vpc_subnet_cidr_block" {
    description = "CIDR block for VPC subnet"
    type = string
    default = "192.168.0.0/28"
}

variable "ssh-private-key" {
    description = "Private key of Ansible Master to run playbook"
    type = string
    default = "~/.ssh/id_rsa"
}