provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tfmyec2" {
  ami = lookup(var.myami, terraform.workspace)                                      # var.myami değişkenindeki haritalamayı kullanarak çalışma alanına özgü AMI (Amazon Machine Image) ID'sini belirler. terraform.workspace, şu anki çalışma alanını temsil eder.
  instance_type = "${terraform.workspace == "dev" ? "t3a.medium" : "t2.micro"}"     # Eğer çalışma alanı "dev" ise "t3a.medium", değilse "t2.micro" kullanılır.
  count = "${terraform.workspace == "prod" ? 3 : 1}"                                # Eğer çalışma alanı "prod" ise 3 örnek oluşturulur, değilse 1 örnek oluşturulur.
  key_name = "second-key-pair"
  tags = {
    Name = "${terraform.workspace}-server"
  }
}

variable "myami" {
  type = map(string)                      # (map) terimi, bir dizi anahtar-değer çiftini içeren veri yapısını ifade eder.
  default = {
    default = "ami-051f7e7f6c2f40dc1"
    dev     = "ami-026ebd4cfe2c043b2"
    prod    = "ami-053b0d53c279acc90"
  }
  description = "in order of an Amazon Linux 2023 ami, Red Hat Enterprise Linux 8 ami, and Ubuntu Server 22.04 LTS ami's"


#  terraform workspace --help
#  terraform workspace list
#  terraform workspace show
#  terraform workspace new dev
#  terraform workspace select dev
#  terraform workspace delete dev
