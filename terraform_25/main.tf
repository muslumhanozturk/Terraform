//This Terraform Template creates 4 Ansible Machines on EC2 Instances
//Ansible Machines will run on Amazon Linux 2023 and Ubuntu 22.04 with custom security group
//allowing SSH (22) and HTTP (80) connections from anywhere.
//User needs to select appropriate variables from "tfvars" file when launching the instance.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  # secret_key = ""
  # access_key = ""
}

locals {
  user = "mhan"
  path = "//wsl.localhost/Ubuntu-22.04/home/muslumhanozturk/test"
}

resource "aws_instance" "nodes" {
  ami = element(var.myami, count.index)
  instance_type = var.instancetype
  count = var.num
  key_name = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  tags = {
    Name = "${element(var.tags, count.index)}_${local.user}"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "tf-sec-gr" {
  name = "ansible-lesson-sec-gr-${local.user}"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "ansible-session-sec-gr-${local.user}"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "config" {
  depends_on = [aws_instance.nodes[0]]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cp ./ansible.cfg ${local.path}/"
  }

  provisioner "local-exec" {
    command = "cp ~/.ssh/${var.mykey}.pem ${local.path}/${var.mykey}.pem"
  }

  provisioner "local-exec" {
    command = "echo [webservers] >> ${local.path}/inventory.txt"
  }

  provisioner "local-exec" {
    command = "echo node1 ansible_host=${aws_instance.nodes[0].public_ip} ansible_ssh_private_key_file=~/${var.mykey}.pem ansible_user=ec2-user >> ${local.path}/inventory.txt"
  }

  provisioner "local-exec" {
    command = "echo node2 ansible_host=${aws_instance.nodes[1].public_ip} ansible_ssh_private_key_file=~/${var.mykey}.pem ansible_user=ec2-user >> ${local.path}/inventory.txt"
  }  

  provisioner "local-exec" {
    command = "echo [ubuntuservers] >> ${local.path}/inventory.txt"
  }

  provisioner "local-exec" {
    command = "echo node3 ansible_host=${aws_instance.nodes[2].public_ip} ansible_ssh_private_key_file=~/${var.mykey}.pem ansible_user=ubuntu >> ${local.path}/inventory.txt"
  }
  provisioner "local-exec" {
    command = "chmod 400 ${local.path}/${var.mykey}.pem"
  }
}

output "controlnodeip" {
  value = aws_instance.nodes[0].public_ip
}