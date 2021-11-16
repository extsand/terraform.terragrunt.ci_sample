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
resource "aws_route_table" "route_for_vpc_codebuild-to-igw" {
	vpc_id = aws_vpc.codebuild_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.vpc_igw.id
	}
	tags = {
		Name = "route for Codebuild aws"
	}
	
}

resource "aws_subnet" "public_a" {
	availability_zone = "eu-central-1a"
	vpc_id = aws_vpc.codebuild_vpc.id
	cidr_block = "10.0.10.0/24"
	map_public_ip_on_launch = true
	tags = {
		Name = "Public subnet A"
	}
}


resource "aws_subnet" "public_b" {
	availability_zone = "eu-central-1b"
	vpc_id = aws_vpc.codebuild_vpc.id
	cidr_block = "10.0.20.0/24"
	map_public_ip_on_launch = true
	tags = {
		Name = "Public subnet b"
	}
}

resource "aws_route_table_association" "rta_public_a" {
	subnet_id = aws_subnet.public_a.id
	route_table_id = aws_route_table.route_for_vpc_codebuild-to-igw.id
}
resource "aws_route_table_association" "rta_public_b" {
	subnet_id = aws_subnet.public_b.id
	route_table_id = aws_route_table.route_for_vpc_codebuild-to-igw.id
}





