provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tfmyec2" {
  ami = lookup(var.myami, terraform.workspace)
  instance_type = "${terraform.workspace == "dev" ? "t3a.medium" : "t2.micro"}"
  count = "${terraform.workspace == "prod" ? 3 : 1}"
  key_name = "<your-pem-file>"
  tags = {
    Name = "${terraform.workspace}-server"
  }
}

variable "myami" {
  type = map(string)
  default = {
    default = "ami-051f7e7f6c2f40dc1"
    dev     = "ami-026ebd4cfe2c043b2"
    prod    = "ami-053b0d53c279acc90"
  }
  description = "in order of an Amazon Linux 2023 ami, Red Hat Enterprise Linux 8 ami, and Ubuntu Server 22.04 LTS ami's"
