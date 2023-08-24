# Making a terraform application by assigning the IAM role on an AWS EC2 instance
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

}

resource "aws_instance" "tf-ec2" {
  ami = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name = "oliver"
  tags = {
    "Name" = "tf-ec2" 
  }
}


resource "aws_s3_bucket" "tf-s3" {
  bucket = "oliver-tf-test-bucket-lesson1"
  
}
