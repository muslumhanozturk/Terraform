provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}

variable "num_of_buckets" {        # This block defines a variable where users can change the number of S3 buckets. It is set to 2 by default.
  default = 2
}

variable "s3_bucket_name" {
  default     = "mhan-new-s3-bucket-addwhateveryouwant"
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "${var.s3_bucket_name}-${count.index}"     ### < ---
  count = var.num_of_buckets                          ### < ---
# count = var.num_of_buckets != 0 ? var.num_of_buckets : 3      # conditional expressions
}
