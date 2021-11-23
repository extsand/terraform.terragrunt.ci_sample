# Important for terragrunt
# configure s3 for tfstate files storage for module

variable "remote_state_bucket" {}

terraform {
  backend "s3" {
    # region         = var.aws_region
    # encrypt        = true
  }
  required_providers {
    aws = {
      version = "~> 3.35"
    }
  }
}


# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state"
#     key            = "frontend-app/terraform.tfstate"
#     region         = var.aws_region
#     encrypt        = true
#     dynamodb_table = "my-lock-table"
#   }
# }