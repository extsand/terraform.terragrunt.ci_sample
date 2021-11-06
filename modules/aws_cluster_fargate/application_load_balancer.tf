resource "aws_alb" "app_load_balancer" {
	name = "${local.name_generator}-load-balancer"
	subnets = aws_subnet.public.*.id								
	security_groups = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_alb_target_group" "app_target_group" {
	name = "${local.name_generator}-targer-group"
	port = 80
	protocol = "HTTP"
	target_type = "ip"
	vpc_id = aws_vpc.vpc_cluster.id

	health_check {
		healthy_threshold = 3
		unhealthy_threshold = 2
		timeout = 3
		interval = 30
		protocol = "HTTP"
		matcher = "200"
		path = var.health_check_path

	}
}

#Redirect all trafic from Application Load Balancer to Target Group 
resource "aws_alb_listener" "app_listener" {
	load_balancer_arn = aws_alb.app_load_balancer.id
	port = var.app_port
	protocol = "HTTP"
	# If we use HTTPS - we will add SSL  
	# protocol = "HTTPS"
	# ssl_policy = "ELBSecurityPolicy-2016-08"
	# certificate_arn = "arn:aws:iam::xxxxxxxxxxxxxxx:server-certificate/name_of_sertificate"

	default_action {
		target_group_arn = aws_alb_target_group.app_target_group.id
		type = "forward"
	}


}














