variable "aws_region" {
	type = string
	# default = "eu-central-1"
}
variable "aws_profile" {
	type = string
	# default = "default"
	
}

variable "environment" {
	type = string
	# default = "dev"
}



variable "app_name" {
	type = string
	# default = "perfectapp"
}


variable "git_token" {
	type = string
}
variable "repo_url" {
	type = string
}

variable "branch_pattern" {
	type = string
	default = "^refs/heads/dev-fargate$"
}
variable "git_trigger_event" {
	type = string
	# default = "push"
}
variable "buildspec" {
	type = string
}

variable "vpc-cluster-id" {
	type = string
	default = null
}
variable "private-subnets" {
	type = list

}


variable "project_tags" {
	type = map
	# default = {
	# 	"project" = "DevOps Academy Example"
	# 	"owner" = "extsand"
	# }
	description = "Set project tags"
}

locals {
	name_generator = "${var.app_name}-${var.environment}"
}