# Associate the S3 package with the Dynamodb table.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.14.0"
    }
  }

  backend "s3" {
    bucket = "tf-remote-s3-bucket-mhan"              # is the Amazon S3 bucket where the stop files will be stored.
    key = "env/dev/tf-remote-backend.tfstate"        # Specifies the path to the stop file.
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

# resource "aws_s3_bucket" "tf-test-1" {               # When we apply these two resource codes in turn, we see that the .tfstate file in the s3 bucket is versioned.
#   bucket = "clarusway-test-1-versioning"
# }

# resource "aws_s3_bucket" "tf-test-2" {
#   bucket = "clarusway-test-2-versioning"
# }

