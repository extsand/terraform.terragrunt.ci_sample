
#ECS task execution role data
# Main IAM Policy for all IAM
#====================================================
data "aws_iam_policy_document" "ecs_task_execution_role" {
	version = "2012-10-17"
	statement {
		sid = ""
		effect = "Allow"
		actions = ["sts:AssumeRole"]

		principals {
			type = "Service"
			identifiers = ["ecs-tasks.amazonaws.com"]
		}
	}

}

#ECS task execution role
# IAM for Task Definition 
#====================================================
resource "aws_iam_role" "ecs_task_execution_role" {
	name = local.ecs_task_execution_role
	assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

#ECS task execution role policy attachment
# Settings for IAM Task Definition role
#NOT SURE ABOUT IT????
#====================================================
resource "aws_iam_role_policy" "ecs_task_execution_role" {
	name_prefix = "ecs_iam_role_policy"
	role = aws_iam_role.ecs_task_execution_role.id
	# policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
	# Grab data from template
	policy      = data.template_file.ecs_service_policy_template_file.rendered
}


# ECS Task Role
#====================================================
resource "aws_iam_role" "ecs_task_role" {
	name = "${local.name_generator}-${local.ecs_task_role_name}"
	assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# ECS Task Role policy
#====================================================
resource "aws_iam_role_policy" "ecs_task_role_policy" {
	name = "${local.name_generator}-${local.ecs_task_role_name}-policy"
	role = aws_iam_role.ecs_task_role.id
	policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


data "template_file" "ecs_service_policy_template_file" {
  # Allow logs for cloudwatch
  # Allow ecs & ecr access as per
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
  #
  # Allow ec2 describe instances so that the instance can see its own metadata if needed
  #
  # Allow param store access only to the namespace of this cluster
  # You can/should create even more granular param access depending
  # on the additional services you run in this cluster.
  #
  # Please read:
  # https://aws.amazon.com/blogs/mt/the-right-way-to-store-secrets-using-parameter-store/
  # for additional steps you can take to impart least permissions with ECS.
  #
  # Note: Once you have created a Key Manage Service (KMS) key for this ECS service,
  # kms access should be limited to that KMS key.
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe",
        "ec2:DescribeInstances"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": [
        "arn:aws:ssm:*:*:parameter/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:*:*:secret:*"
      ]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
         "kms:ListKeys",
         "kms:ListAliases",
         "kms:Describe*",
         "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}