variable "app_name" {
	type = string
	default = "perfectapp"
}
variable "app_port" {
	type = string
	default = "80"
}
variable "app_count" {
	type = string
	default = "2"
	description = "number of docker containers to run in cluster"
}



variable "image_tag" {
	type = string
	default = "latest"
	description = "should be grab from github commit"
}

variable "ecr_repository_url" {
  type = string
	default = "530117518858.dkr.ecr.eu-central-1.amazonaws.com/docker_app"
}

# variable "app_image" {
# 	type = string
# 	default = format("%s:%s", var.ecr_repository_url, var.image_tag)
# }


variable "project_tags" {
	type = map
	default = {
		"project" = "DevOps Academy Example"
		"owner" = "extsand"
	}
	description = "Set project tags"
}



variable "environment" {
	type = string
	default = "dev"
}
variable "profile" {
	type = string
	default = "default"
	
}

# variable "name_generator" {
# 	type = string
# 	default = "${var.app_name}-${var.environment}"
# 	description = "Naming generator for project resources"
# }




variable "aws_region" {
	type = string
	default = "eu-central-1"
}
variable "az_count" {
	type = string
	default = "2"
	description = "Number of availability zones in region"
}


variable "ami" {
  type    = string
  default = "ami-05f7491af5eef733a"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}



# variable "ecs_task_execution_role" {
# 	type = string
# 	default = "${var.app_name}-iam-role"
# 	description = "ECS task execution role name"
# }

# variable "ecs_task_role_name" {
# 	type = string
# 	default = "${var.app_name}-task-role"
# 	description = "ECS task role name"
# }

variable "health_check_path" {
	type = string
	default = "/"
	description = "health checker"
}



variable "fargate_cpu" {
	default = "512"
	description = "Fargate instance CPU"	
}
variable "fargate_memory" {
	default = "1024"
	description = "Fargare instance memory"
}



variable "task_definition_template" {
	type = string
	default = "task_definition_template.json.tpl"
	# default = "container_definition.json.tpl"
	description = "Path to file with template for task definition"
}

locals {
	name_generator = "${var.app_name}-${var.environment}"
	app_image = format("%s:%s", var.ecr_repository_url, var.image_tag)
	ecs_task_execution_role = "${var.app_name}-${var.environment}-task-exec-role"
	ecs_task_role_name = "${var.app_name}-${var.environment}-task-role"
}