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

data "aws_ami" "tf_ami" {         # This line defines a new aws_ami datasource in the data block.This resource is used to query AWS AMIs and select those with certain characteristics.
  most_recent = true              # This parameter enables the selection of the most recently created AMI. So it chooses the most recent one.
  owners = ["self"]               # "self" here refers to your current account. i.e. it is used to import AMIs that you create yourself.

  filter {                        # Filters are used to query AMIs based on the properties you want.
    name = "virtualization-type"  # Wants to filter AMIs by virtualization type
    values = ["hvm"]              # It will select AMIs with virtualization type "hvm" (Hardware Virtual Machine).
  }

  filter {
    name = "architecture"         # Used to query AMIs by architecture.
    values = ["x86_64"]           # It will select AMIs with x86_64 architecture.
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
