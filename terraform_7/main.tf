terraform {
  required_providers {
    aws = {                              # (part 1-9) When we create a resource, the "USE PROVIDER" code of that provider (for example, aws provider \
      source = "hashicorp/aws"           # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) \
      version = "5.13.1"                 # is appended to the beginning of the .tf file. . This code loads provider.
    }
  }
}
                                         # (part 10-15) Authentication and Configuration
provider "aws" {                         # Specifies that Terraform will use the AWS provider.
  region  = "us-east-1"                  # Specifies which AWS region the created resources will be located in
  # access_key = "my-access-key"         # HashiCorp recommends that you 'never' hard-code credentials into `*.tf configuration files`.
  # secret_key = "my-secret-key"
  ## profile = "my-profile"              # Allows to use AWS credentials from the AWS CLI configuration. This is a more secure and flexible approach.
}
                                             # (part 17-23) resource block
resource "aws_instance" "tf-ec2" {           # Creates an EC2 instance resource named "tf-ec2".
  ami           = "ami-022e1a32d3f742bd8"    # Specifies the Amazon Machine Image (AMI) code to use.
  instance_type = "t2.micro"                 # It determines the type and size of the created instance.
  tags = {
    "Name" = "created-by-tf"                 # Adds a "created-by-tf" tag to the EC2 instance.
  }
}
