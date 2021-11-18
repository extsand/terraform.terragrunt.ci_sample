data "aws_availability_zones" "available" {}
locals {
	az_count = 2
}


resource "aws_vpc" "codebuild_vpc" {
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default"
	enable_dns_hostnames = true
	enable_dns_support = true
	tags = {
		Name = "Codebuild-VPC"
	}
}

resource "aws_internet_gateway" "vpc_igw" {
	vpc_id = aws_vpc.codebuild_vpc.id
	tags = {
		Name = "Codebuild-VPC"
	}
}
resource "aws_route_table" "route_igw" {
	vpc_id = aws_vpc.codebuild_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.vpc_igw.id
	}
	tags = {
		Name = "route for Codebuild aws"
	}
	
}

resource "aws_subnet" "public" {
	count = local.az_count
	vpc_id = aws_vpc.codebuild_vpc.id
	cidr_block = "10.0.1${count}.0/24"
	availability_zone = data.aws_availability_zones.available
	map_public_ip_on_launch = true
	tags = {
		Name = "Public subnet ${count}"
	}
}

resource "aws_subnet" "private" {
	count = local.az_count
	vpc_id = aws_vpc.codebuild_vpc.id
	cidr_block = "10.0.2${count}.0/24"
	availability_zone = data.aws_availability_zones.available
	map_public_ip_on_launch = false
	tags = {
		Name = "Private subnet ${count}"
	}
}


resource "aws_route_table_association" "rta_public_a" {
	count = local.az_count
	subnet_id = element(aws_subnet.public.*.id, count.index)
	route_table_id = aws_route_table.route_igw.id
}



resource "aws_eip" "eip_for_nat" {
	count = local.az_count
	vpc = true
	depends_on = [
		aws_internet_gateway.vpc_igw
	]
}
resource "aws_nat_gateway" "nat_for_private" {
	count = local.az_count
	allocation_id = element(aws_eip.eip_for_nat.*.id, count.index)
	subnet_id = element(aws_subnet.public.*.id, count.index)
}
resource "aws_route_table" "route_private_nat" {
	count = local.az_count
	vpc_id = aws_vpc.codebuild_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = element(aws_nat_gateway.nat_for_private.*.id, count.index)
	}
}
resource "aws_route_table_association" "rta_nat" {
	count = local.az_count
	subnet_id = element(aws_subnet.private.*.id, count.index)
	route_table_id = element(aws_route_table.route_private_nat.*.id, count.index)
}
