terraform {
  required_providers {
    aws = {                              # (part 1-9) When we create a resource, the "USE PROVIDER" code of that provider (for example, aws provider \
      source = "hashicorp/aws"           # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) \
      version = "5.13.1"                 # is appended to the beginning of the .tf file. . This code loads provider.
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  ## profile = "my-profile"
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  tags = {
    "Name" = "created-by-tf"
  }
}
