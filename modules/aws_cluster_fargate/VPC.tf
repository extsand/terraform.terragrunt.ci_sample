# Grab Availability zones from Region
data "aws_availability_zones" "available"{
}


# Create VPC
#====================================================
resource "aws_vpc" "vpc_cluster" {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "${local.name_generator}-VPC"
	}
}


# Create Internet Gateway
#====================================================
resource "aws_internet_gateway" "vpc_internet_gateway" {
	vpc_id = aws_vpc.vpc_cluster.id
	tags   = merge(var.project_tags, { Name = "Internet_Gateway_${local.name_generator}" })
}
# Create Route Table for Internet Gateway
#====================================================
resource "aws_route_table" "route_table_to_internet_gateway" {
	vpc_id = aws_vpc.vpc_cluster.id
	
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.vpc_internet_gateway.id
	}

	tags = merge(var.project_tags, { Name = "Route_table_to_Internet_Gateway_${local.name_generator}" })
}



# Create Private Subnets
#====================================================
resource "aws_subnet" "private" {
	vpc_id = aws_vpc.vpc_cluster.id
	count = var.aws_az_count
	# cidr_block = cidrsubnet(aws_vpc.vpc_cluster.cidr_block, 8, count.index + 1)
	cidr_block = "10.0.2${count.index}.0/24"
	availability_zone = data.aws_availability_zones.available.names[count.index]
	map_public_ip_on_launch = false

	tags = merge(var.project_tags, { Name = "Private_subnet-${count.index}-${local.name_generator}"})

}

# Create Public Subnets
#====================================================
resource "aws_subnet" "public" {
	vpc_id = aws_vpc.vpc_cluster.id
	count = var.aws_az_count
	# cidr_block = cidrsubnet(aws_vpc.vpc_cluster.cidr_block, 8, count.index + 1)
	cidr_block = "10.0.1${count.index}.0/24"

	availability_zone = data.aws_availability_zones.available.names[count.index]
	map_public_ip_on_launch = true

	tags = merge(var.project_tags, { Name = "Public_subnet-${count.index}-${local.name_generator}"})

}



# Create Route Assotiation betwen Public Subnets and Route table
#====================================================
resource "aws_route_table_association" "assotiation_public_to_internet_gateway" {
	# subnet_id = aws_subnet.public.id #???
	count = var.aws_az_count
	subnet_id = element(aws_subnet.public.*.id, count.index)
	route_table_id = aws_route_table.route_table_to_internet_gateway.id
}

# Create NAT for Private Subnets
#====================================================
#Don't forget - NAT will be installing only to Public Subnet

resource "aws_eip" "eip_for_nat" {
	count = var.aws_az_count
	vpc = true #for what?
	depends_on = [
		aws_internet_gateway.vpc_internet_gateway
	]
	tags = merge(var.project_tags, { Name = "eip_for_nat_a_${local.name_generator}" })
}

resource "aws_nat_gateway" "nat_gw_for_private" {
	count = var.aws_az_count
	allocation_id = element(aws_eip.eip_for_nat.*.id, count.index)
	subnet_id = element(aws_subnet.public.*.id, count.index)
	tags = merge(var.project_tags, { Name = "NAT_Gateway-${count.index}-${local.name_generator}" })
}

resource "aws_route_table" "table_for_private_to_nat" {
	count = var.aws_az_count
	vpc_id = aws_vpc.vpc_cluster.id

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = element(aws_nat_gateway.nat_gw_for_private.*.id, count.index)
	}
	tags = merge(var.project_tags, { Name = "Route_table_for_private-${count.index}-${local.name_generator}" })
}

resource "aws_route_table_association" "assotiation_private_to_nat" {
	count = var.aws_az_count
	subnet_id = element(aws_subnet.private.*.id, count.index)
	route_table_id = element(aws_route_table.table_for_private_to_nat.*.id, count.index)
}


