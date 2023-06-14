terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.2.0"
    }
  } 
}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.access-key
  secret_key = var.secret-access-key
}

# Configure data source for the EC2 instance
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = var.ami_owner #["850267594901"] # Canonical
}

resource "aws_instance" "EC2instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance-type

  tags = {
    Name = "Terraform instance"
  }
}

# Configure SSH key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.SSH-public-key
}

# Configure VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpv_cidr_block #"192.168.0.0/20"
}

# configure VPC subnet
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_subnet_cidr_block #"192.168.0.0/28"

  tags = {
    Name = "vpc subnet"
  }
}

# Create association between subnet and VPC
#resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
#  vpc_id     = aws_vpc.vpc.id
# cidr_block = "192.168.0.0/28"
#}

# Configure security group for EC2 instance
resource "aws_security_group" "allow_app_traffic" {
  name        = "allow_app_traffic"
  description = "Allow application inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "app traffic from VPC"
    from_port        = 0
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_app_traffic"
  }
}

