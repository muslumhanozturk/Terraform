terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"                 # It will get the greater than zero update in 5.0
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
  ami = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name = "second-key-pair"
  vpc_security_group_ids = [ aws_security_group.tf-sec-gr.id ]       # security_groups = ["tf-provisioner-sg"] this is not recommended
  tags = {
    Name = "terraform-instance-with-provisioner"
  }

  provisioner "local-exec" {                                                 # On the machine running terraform, it creates the "public_ip.txt" file and writes public ip in it.
    command = "echo http://${self.public_ip} > public_ip.txt"             
  }

  connection {
    host = self.public_ip
    type = "ssh"                                                            # ssh -i "second-key-pair.pem" ec2-user@ec2-54-224-247-247.compute-1.amazonaws.com  works the same as this
    user = "ec2-user"
    private_key = file("/home/ec2-user/Provisioners/second-key-pair.pem")
  }

  provisioner "remote-exec" {                                                # runs commands on remote resource
    inline = [ 
      "sudo dnf -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
     ]
  }

  provisioner "file" {                                                       # It is used to copy files, directories from the machine running terraform to the newly created resource.
    content = self.public_ip
    destination = "/home/ec2-user/my_public_ip.txt"
  }

}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-provisioner-sg"
  tags = {
    Name = "tf-provisioner-sg"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      protocol = "tcp"
      to_port = 22
      cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
      from_port = 0
      protocol = -1
      to_port = 0
      cidr_blocks = [ "0.0.0.0/0" ]
  }
}
