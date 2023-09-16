terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}
resource "aws_security_group" "sg" {
  name        = "sg"
  description = "only ssh Security Group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform_test" {
    ami = "ami-08a52ddb321b32a8c"
    instance_type = "t2.micro"
    key_name = "second-key-pair"
    tags = {
        "Name" = "terraform-test"  
    }
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y yum-utils
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    dnf -y install terraform
    EOF
    }