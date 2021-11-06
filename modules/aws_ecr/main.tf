locals {
  repository_name = format("%s-%s", var.app_name, var.environment)
}

resource "aws_ecr_repository" "ecr_repository" {
  name = local.repository_name
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}



