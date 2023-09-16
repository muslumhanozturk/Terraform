output "public_ip_80" {
  value = "http://${aws_instance.instance.public_ip}:80"
  depends_on = [ aws_instance.instance ]
}

output "public_ip_books" {
  value = "http://${aws_instance.instance.public_ip}:80/books"
  depends_on = [ aws_instance.instance ]
}

output "github_repo_name" {
  value = "This repo name ${github_repository.bookstore-project.name} repository"
  depends_on = [ github_repository.bookstore-project ]
}

