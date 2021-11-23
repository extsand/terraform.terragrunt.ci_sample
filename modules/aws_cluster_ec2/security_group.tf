# Create Security Group for VPC
#====================================================
resource "aws_security_group" "vpc_ssh_sg" {
  vpc_id = aws_vpc.vpc_cluster.id
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.project_tags, { Name = "SSH_Enable_SG-${local.name_generator}" })

}

# Create Security Group for Application Load Balancer
#====================================================
resource "aws_security_group" "load_balancer_security_group" {
	name = "${local.name_generator}-load_balancer_sg"
	description = "Access to Application Load Balancer"
	vpc_id = aws_vpc.vpc_cluster.id

	ingress {
		protocol = "tcp"
		from_port = var.app_port
		to_port = var.app_port
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		protocol = "-1"
		from_port = 0
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge(var.project_tags, { Name = "App_Load_Balancer_SG-${local.name_generator}" })

}
# Create Security Group for traffic 
# This SG working like Filter for traffic
# All traffic will be come from Application Load Balancer
#====================================================
resource "aws_security_group" "ecs_tasks_security_group" {
	
	vpc_id = aws_vpc.vpc_cluster.id
	ingress {
		protocol = "tcp"
		from_port = var.app_port
		to_port = var.app_port
		security_groups = [aws_security_group.load_balancer_security_group.id]
	}

	egress {
		protocol = "-1"
		from_port = 0
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge(var.project_tags, { Name = "ECS_tasks_SG-${local.name_generator}" })
}

