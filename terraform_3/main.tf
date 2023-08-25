terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

variable "ec2_name" {
  default = "mhan-ec2"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-08a52ddb321b32a8c"
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  key_name      = "second-key-pair"
  tags = {
    "Name" = "${var.ec2_name}-instance"
  }
}

variable "s3_bucket_name" {
  default = "mhan-s3-bucket-variable-addwhateveryouwant"
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = var.s3_bucket_name
}

output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}

output "tf-example-s3" {
  value = aws_s3_bucket.tf-s3[*]
}
