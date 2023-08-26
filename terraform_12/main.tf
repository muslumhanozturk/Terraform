terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.14.0"
    }
  }

  backend "s3" {
    bucket = "tf-remote-s3-bucket-mhan"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
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

# resource "aws_s3_bucket" "tf-test-1" {
#   bucket = "clarusway-test-1-versioning"
# }

# resource "aws_s3_bucket" "tf-test-2" {
#   bucket = "clarusway-test-2-locking-2"
# }

