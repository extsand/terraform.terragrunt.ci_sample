[
  {
    "name": "${app_name}-${env}-app",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
		"image": "${app_image}:${image_tag}",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
					"awslogs-group":"/ecs/${app_name}-${env}-log",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
				"protocol": "tcp",
        "containerPort": ${app_port} ,
        "hostPort": ${app_port}
      }
    ],
    "environment": [
      {
        "name": "VERSION",
        "value": "${image_tag}"
      }
    ]
  }
]
