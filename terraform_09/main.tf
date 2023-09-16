locals {                          # A local value assigns a name to an expression, so you can use it multiple times within a module without repeating it.
    mytag = "mhan-local-name"
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
    Name = "${local.mytag}-come from locals"                  ###   < ---
  }
}

variable "s3_bucket_name" {
  default = "mhan-s3-bucket-variable-addwhateveryouwant"
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = var.s3_bucket_name
  tags = {
    Name = "${local.mytag}-come-from-locals"                  ###   < ---
  }
}
