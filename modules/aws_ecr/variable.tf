variable "aws_region" {
	type = string
	default = "eu-central-1"
}
variable "app_name" {
	type = string
	default = "best_app_ever_you_see"

}
variable "environment" {
	type = string
	default = "development"
}
variable "aws_profile" {
	type = string
  	description = "aws profile"
	default = "default"
}
