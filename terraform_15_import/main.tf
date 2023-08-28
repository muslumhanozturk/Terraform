- Bringing existing infrastructure under Terraform's control involves five main steps:

  1. Identify the existing infrastructure to be imported.
  2. Import infrastructure into your Terraform state.
  3. Write Terraform configuration that matches that infrastructure.
  4. Review the Terraform plan to ensure the configuration matches the expected state and infrastructure.
  5. Apply the configuration to update your Terraform state.

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
}

variable "tf-ami" { 
  type = list(string)                                         # It is stated that the type of the variable is a list and the items in this list are of text (string) type.                          
  default = ["ami-051f7e7f6c2f40dc1", "ami-053b0d53c279acc90", "ami-026ebd4cfe2c043b2"]
}

variable "tf-tags" {
  type = list(string)
  default = ["aws-linux-2023", "ubuntu-22.04", "red-hat-linux-9"]
}

resource "aws_instance" "tf-instances" {                       # In order to import, the resource block and the existing resource must have the same content.
  ami = element(var.tf-ami, count.index )                      # 'var.tf-ami' değişkeni içinde bulunan AMI'ların, 'count.index' değeri kadar elemanlarını sırayla kullanır.
  instance_type = "t2.micro"
  count = 3
  key_name = "second-key-pair"            // change here
  vpc_security_group_ids = [ aws_security_group.tf-sg.id ]
  tags = {
    Name = element(var.tf-tags, count.index )                  # 'var.tf-tags' değişkeni içinde bulunan etiketler, 'count.index' değeri kadar elemanlarını sırayla kullanır.
  }
}

resource "aws_security_group" "tf-sg" {                       # In order to import, the resource block and the existing resource must have the same content.
  name = "tf-import-sg"
  description = "terraform import security group"
  tags = {
    Name = "tf-import-sg"
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


terraform init
terraform import aws_security_group.tf-sg sg-01b92e29e828a2177         # If there is already a security group in the cloud, it is imported with this command. 
terraform import "aws_instance.tf-instances[0]" i-090291cc33c16504c    # If the instance already exists in the cloud, it is imported with this command.
terraform import "aws_instance.tf-instances[1]" i-092fe70d1cef163c1
