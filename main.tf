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

  owners = var.ami_owner
}

# Configure SSH key pair
resource "aws_key_pair" "genkey" {
  key_name   = "pub-key"
  public_key = "${file(var.ssh-public-key)}"
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
  ingress  {
    description    = "allow port SSH"
    from_port      = "22"
    to_port        = "22"
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
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

resource "aws_instance" "ec2instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance-type
  associate_public_ip_address = "true"
  key_name = "pub-key"
  
    connection {
      type = "ssh"
      host = aws_instance.ec2instance.public_dns
      private_key = "${file(var.ssh-private-key)}"
      user = "ubuntu"
    }
  
  provisioner "local-exec" {
    command = <<EOT
    sleep 120 && \
    > hosts && \
    echo "[ansibletarget]" | tee -a hosts && \
    echo "${aws_instance.ec2instance.public_ip} ansible_user= ansible_ssh_private_key_file=${var.ssh-private-key}" | tee -a hosts && \
    export ANSIBLE_HOST_KEY_CHECKING=False && \
    echo "${aws_instance.ec2instance.public_ip} ansible_user= ansible_ssh_private_key_file=${var.ssh-private-key}" | tee -a hosts && \
    export ANSIBLE_HOST_KEY_CHECKING=False && \
    ansible-playbook -u ubuntu --private-key ${var.ssh-private-key} -i hosts roles.yml
  EOT
  }

  depends_on = [aws_instance.ec2instance]
}
