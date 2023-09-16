resource "github_repository" "bookstore-project" {
  name        = "bookstore-project"
  description = "This bookstore-project repository was created with terraform"
  auto_init   = true
  visibility  = "private"
}

resource "github_repository_file" "README" {
  content             = file("${path.module}/README.md ")
  file                = "README.md"
  repository          = "bookstore-project"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.bookstore-project]
}

resource "github_repository_file" "bookstore-api" {
  content             = file("${path.module}/bookstore-api.py")
  file                = "bookstore-api.py"
  repository          = "bookstore-project"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.bookstore-project]
}

resource "github_repository_file" "requirements" {
  content             = file("${path.module}/requirements.txt")
  file                = "requirements.txt"
  repository          = "bookstore-project"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.bookstore-project]
}

resource "github_repository_file" "main" {
  content             = file("${path.module}/main.tf  ")
  file                = "main.tf"
  repository          = "bookstore-project"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.bookstore-project]
}

resource "github_repository_file" "docker-compose" {
  content             = file("${path.module}/docker-compose.yml")
  file                = "docker-compose.yml"
  repository          = "bookstore-project"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.bookstore-project]
}

resource "github_repository_file" "Dockerfile" {
  content             = file("${path.module}/Dockerfile")
  file                = "Dockerfile"
  repository          = "bookstore-project"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.bookstore-project]
}

###

data "aws_ami" "amzn2" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "name"
    values = ["amzn2-ami-kernel*"]
  }
}

resource "aws_security_group" "sec-gr" {
  name = "bookstore-proje-sec-gr"
  tags = {
    Name = "bookstore-proje-sec-gr"
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

resource "aws_instance" "instance" {
  ami = data.aws_ami.amzn2.id
  instance_type = var.instance-type
  key_name = var.key-name
  vpc_security_group_ids = [ aws_security_group.sec-gr.id ]       # security_groups = ["tf-provisioner-sg"] this is not recommended
  user_data = base64encode(templatefile("userdata.sh", {user-data-git-token = var.git-token, user-data-git-name = var.git-name}))
  depends_on = [ github_repository_file.Dockerfile ]
  tags = {
    Name = "Web Server of Bookstore"
  }
}

