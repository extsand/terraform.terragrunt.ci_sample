resource "aws_appautoscaling_target" "ecs_target" {
	service_namespace = "ecs"
	resource_id = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.app_service.name}"
	scalable_dimension = "ecs:service:DesiredCount"
	
	min_capacity = 1
	max_capacity = 1
	
}

#Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "ecs_policy_up" {
	name = "${local.name_generator}-scale_up"
	# policy_type = "StepScalling"
	resource_id = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.app_service.name}"
	scalable_dimension = "ecs:service:DesiredCount"
	service_namespace = "ecs"
	step_scaling_policy_configuration {
		adjustment_type = "ChangeInCapacity"
		cooldown = 60
		metric_aggregation_type = "Maximum"

		step_adjustment {
			metric_interval_upper_bound = 0
			scaling_adjustment = 1
		}
	}

	depends_on = [aws_appautoscaling_target.ecs_target]
}

#Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "ecs_policy_down" {
	name = "${local.name_generator}-scale_down"
	# policy_type = "StepScalling"
	resource_id = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.app_service.name}"
	scalable_dimension = "ecs:service:DesiredCount"
	service_namespace = "ecs"

	step_scaling_policy_configuration {
		adjustment_type = "ChangeInCapacity"
		cooldown = 60
		metric_aggregation_type = "Maximum"

		step_adjustment {
			metric_interval_upper_bound = 0
			scaling_adjustment = -1
		}
	}

	depends_on = [aws_appautoscaling_target.ecs_target]
}
