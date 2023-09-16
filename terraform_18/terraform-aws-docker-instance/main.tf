data "aws_ami" "amazon-linux-2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.sh")       #${abspath(path.module)} ifadesi, bu Terraform modülünün bulunduğu dizinin tam yolunu döndürür.
  vars = {
    myserver = var.server-name
  }
}

resource "aws_instance" "tfmyec2" {
  ami = data.aws_ami.amazon-linux-2023.id
  instance_type = var.instance_type
  count = var.num_of_instance
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  user_data = data.template_file.userdata.rendered
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name = "${var.tag}-terraform-sec-grp"
  tags = {
    Name = var.tag
  }

  dynamic "ingress" {                        # dynamic bloğu, belirli port numaralarını döngü ile alarak bu portlar için gelen trafiğe izin veren kuralları oluşturuyor.
    for_each = var.docker-instance-ports     # döngüde kullanılacak olan elemanları belirler.
    iterator = port                          # her döngü adımında kullanılacak olan iterator (döngü değişkeni) adını belirtir. burada port döngü değişkeni
    content {                                # içerik bloğu, her bir port numarası için gelen trafiğe izin veren bir güvenlik grubu kuralı oluşturur.
      from_port = port.value                 # her adımda farklı bir port numarası kullanılır.
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]            # tüm adreslerden gelen trafiği kabul edecek.
    }
  }

  egress {
    from_port =0
    protocol = "-1"
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
