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
