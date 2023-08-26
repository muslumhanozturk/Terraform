terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.14.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  
}

locals {
  mytag = "clarusway-local-name"
}

variable "ec2-type" {
    default = "t2.micro"
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  
}

resource "aws_instance" "tf-ec2" {
    ami = data.aws_ami.tf_ami.id
    instance_type = var.ec2-type
    key_name = "second-key-pair"
    tags = {
        Name = "${local.mytag}-this is from my-ami"
    }
  
}
