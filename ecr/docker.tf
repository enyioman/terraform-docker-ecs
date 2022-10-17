resource "docker_image" "centos_image" {
  name = "centos:latest"
}

resource "aws_ecr_repository" "ecr_project_repo" {
  name = "ecr-project-repo"
}