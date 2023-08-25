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

variable "num_of_buckets" {
  default = 0
}

variable "s3_bucket_name" {
  default     = "mhan-new-s3-bucket-addwhateveryouwant"
}

resource "aws_s3_bucket" "tf-s3" {
  # bucket = "${var.s3_bucket_name}-${count.index}"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 1
  for_each = toset(var.users)                                     # Bu satır, var.users listesinde bulunan her bir kullanıcı için bir S3 kovası oluşturulacağını belirtir. 
  bucket   = "example-tf-s3-bucket-${each.value}"                 # for_each kullanıldığında, her bir öğe üzerinde döngü yapılır ve öğeye özgü kaynaklar oluşturulur.
}

resource "aws_iam_user" "new_users" {                            # her bir kullanıcı için IAM kullanıcısı oluşturur.
  for_each = toset(var.users)
  name = each.value
}

output "uppercase_users" {                                           # her bir kullanıcının ismini büyük harfle yazıp, uzunluğu 6 karakterden fazla olanları içerecektir.
  value = [for user in var.users : upper(user) if length(user) > 6]
}
