#important for codebuild
output "vpc_id" {
	value = aws_vpc.vpc_cluster.id
}
output "subnets-private-id" {
	value = aws_subnet.private.*.id
}

# important end


output "vpc_tags" {
	value = aws_vpc.vpc_cluster.tags_all
}

output "app-private-subnet" {
	value = aws_subnet.private.*.cidr_block
}
output "app-public-subnet" {
	value = aws_subnet.public.*.cidr_block
}



output "application_load_balancer_arn" {
	value = aws_alb.app_load_balancer.arn
}


output "application_load_balancer_hostname" {
	value = aws_alb.app_load_balancer.dns_name
}
