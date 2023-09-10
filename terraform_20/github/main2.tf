terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
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
  auto_init   = true
  visibility  = "private"
}

resource "github_repository_file" "README" {
  content             = file("${path.module}/README.md ")
  file                = "README.md"
  repository          = "test"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.test]
}

resource "github_repository_file" "bookstore-api" {
  content             = file("${path.module}/bookstore-api.py")
  file                = "bookstore-api.py"
  repository          = "test"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.test]
}

resource "github_repository_file" "requirements" {
  content             = file("${path.module}/requirements.txt")
  file                = "requirements.txt"
  repository          = "test"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.test]
}

resource "github_repository_file" "main" {
  content             = file("${path.module}/main.tf  ")
  file                = "main.tf"
  repository          = "test"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.test]
}

resource "github_repository_file" "docker-compose" {
  content             = file("${path.module}/docker-compose.yml")
  file                = "docker-compose.yml"
  repository          = "test"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.test]
}

resource "github_repository_file" "Dockerfile" {
  content             = file("${path.module}/Dockerfile")
  file                = "Dockerfile"
  repository          = "test"
  overwrite_on_create = true
  branch              = "main"

  depends_on = [github_repository.test]
}
