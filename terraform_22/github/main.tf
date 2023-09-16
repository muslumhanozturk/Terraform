terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "5.35.0"
    }
  }
}

variable "token" {
  default = "xxxxxxxxxxxxxxxxxxxxxxx"
}

provider "github" {
  token = var.token
}

resource "github_repository" "test" {
  name        = "test"
  description = "My test repository"
  auto_init = true
  visibility = "private"
}

resource "github_repository_file" "test" {
  content = "bu bir terraformtf ile ücüncü testtir"
  file = "test.txt"
  repository = "test"
  overwrite_on_create = true
  branch = "main"

  depends_on = [ github_repository.test ]
}
