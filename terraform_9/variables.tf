variable "ec2_name" {
  default = "mhan-ec2"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-08a52ddb321b32a8c"
}

variable "s3_bucket_name" {
#  default = "mhan-s3-bucket-variable-addwhateveryouwant"    
}


# If the default value of the variables is not entered or if they are commented out, when we enter the "terraform plan" and "terraform apply" command, it asks us to enter this value and we write the value.
# If we don't want him to ask;
# terraform plan -var="s3_bucket_name=mhan-new-s3-bucket"
# terraform apply -var="s3_bucket_name=mhan-new-s3-bucket"
