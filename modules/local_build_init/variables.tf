
variable "aws_region" {
	type = string
	# default = "eu-central-1"
}
variable "aws_profile" {
	type = string
  	description = "aws profile"
	# default = "default"
}


variable "app_name" {
    type = string
	# default = "best_app_ever_you_see"
}
variable "app_tag" {
    type = string
	# default = "init"
}
variable "environment" {
    type = string
	# default = "dev"
}


variable "working_dir" {
    type = string
	# default = "../../app"
}


variable "build_app_command" {
	type = string
	# default = "make debug-mode"
}


