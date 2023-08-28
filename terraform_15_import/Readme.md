terraform init
terraform import aws_security_group.tf-sg sg-01b92e29e828a2177         # If there is already a security group in the cloud, it is imported with this command. 
terraform import "aws_instance.tf-instances[0]" i-090291cc33c16504c
terraform import "aws_instance.tf-instances[1]" i-092fe70d1cef163c1
