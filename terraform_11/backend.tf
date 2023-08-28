# Creating an S3 bucket and a Dynamodb table
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "tf-remote-s3-bucket-mhan"
  force_destroy = true                            # ensures that the contents of the bucket are forcibly deleted when the bucket is deleted, whether or not the bucket has its contents.
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mybackend" {    # This line defines a new AWS S3 bucket server-side encryption configuration resource.
  bucket = aws_s3_bucket.tf-remote-state.bucket                                # This parameter specifies the S3 bucket to which the encryption configuration will be applied.

  rule {                                          # This block defines the encryption rule.
    apply_server_side_encryption_by_default {     # This block specifies that encryption will be applied by default on the server side.
      sse_algorithm = "AES256"                    # This parameter specifies the encryption algorithm to use. It is designated here as "AES256", meaning the 256-bit Advanced Encryption Standard will be used.
    }
  }
}
 
resource "aws_s3_bucket_versioning" "versioning_backend_s3" {                 # This line defines a new AWS S3 bucket versioning resource. 
  bucket = aws_s3_bucket.tf-remote-state.id                                   # This parameter specifies the S3 bucket to apply the versioning feature to.
  versioning_configuration {                                                  # This block specifies the versioning configuration.
    status = "Enabled"                                                        # This parameter specifies the status of the versioning. Here it is marked as "Enabled", meaning the versioning feature is enabled.
  }
}

resource "aws_dynamodb_table" "tf-remote-state-lock" {                        # This line defines a new AWS DynamoDB table resource.
  hash_key = "LockID"                                                         # This parameter specifies the key of the table. Here it is specified as "LockID", so this table will use the "LockID" field as the primary key.
  name     = "tf-s3-app-lock"                                                 # This parameter specifies the name of the table.
  attribute {                                                                 # This block specifies the table attributes.
    name = "LockID"                                                           # This parameter specifies the attribute name.
    type = "S"                                                                # Here it is specified as "S" (String), so the "LockID" field will have a text data type.
  }
  billing_mode = "PAY_PER_REQUEST"                                            # This parameter specifies the billing mode of the table. Here it is specified as "PAY_PER_REQUEST" i.e. pay-per-request mode will be used.
}
