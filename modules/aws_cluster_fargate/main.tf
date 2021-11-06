provider "aws" {
	region = var.aws_region
	profile = var.profile
}


resource "aws_ecs_cluster" "app_cluster" {
	name = "${var.app_name}-${var.environment}-cluster"
}



resource "aws_ecs_service" "app_service" {
	name = "${var.app_name}-${var.environment}-service"
	cluster = aws_ecs_cluster.app_cluster.id
	task_definition =aws_ecs_task_definition.app_task_definition.arn
	desired_count = var.app_count
	launch_type = "FARGATE"

	network_configuration {
		security_groups = [aws_security_group.ecs_tasks_security_group.id] 
		subnets = aws_subnet.private.*.id
		assign_public_ip = true
	}

	load_balancer {
		target_group_arn = aws_alb_target_group.app_target_group.id
		container_name = "${local.name_generator}-app"
		container_port = var.app_port
	}

	depends_on = [
		aws_alb_listener.app_listener,
		aws_iam_role_policy.ecs_task_execution_role
	]
}

# Create Task Definition
#====================================================
resource "aws_ecs_task_definition" "app_task_definition" {
	family = "${var.app_name}-task_definition"
	execution_role_arn = aws_iam_role.ecs_task_execution_role.arn 
	task_role_arn = aws_iam_role.ecs_task_role.arn 

	# execution_role_arn = "arn:aws:iam::530117518858:role/ecsTaskExecutionRole"
	# task_role_arn =  "arn:aws:iam::530117518858:role/perfectapp-dev-perfectapp-task-role"


	network_mode = "awsvpc"
	requires_compatibilities = [ "FARGATE" ]
	
	cpu = var.fargate_cpu
	memory = var.fargate_memory

	# container_name = "${var.app_name}"
	container_definitions = data.template_file.app_template.rendered

}


# FIX THIS FILE DIDN'T EXIST
# Template file for Task Definition
#====================================================
data "template_file" "app_template" {
  template = file(var.task_definition_template)

  vars = {
    app_image      = var.ecr_repository_url
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    env            = var.environment
    app_name       = var.app_name
		image_repo 		 = var.ecr_repository_url
    image_tag      = var.image_tag
  }
	
}



