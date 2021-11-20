terraform {
	source = "../../../modules//aws_codebuild"
}

include {
	path = find_in_parent_folders()
}

# for number of runnings
dependencies {
	paths = ["../aws_cluster_fargate", 
					 "../aws_ecr", 
					 "../local_build_init"]
}



dependency "aws_cluster_fargate"{
	config_path = "../aws_cluster_fargate"
	mock_outputs = {
		subnets-private-id = ["subnet-0000000000000000", "subnet-0000000000000001"]
	}
	# mock_outputs = {
	# 	vpc-cluster = "vpc-000000000000"
	# 	subnets = ["app-private-subnet-0000000", "app-private-subnet-0000001" ]

	# }
}

inputs = {
	# ecr_repository_url = dependency.aws_ecr.outputs.ecr_repository_url
		vpc-cluster-id = dependency.aws_cluster_fargate.outputs.vpc_id
		private-subnets = dependency.aws_cluster_fargate.outputs.subnets-private-id
		# buffer-value = dependency.aws_cluster_fargate.outputs.subnets-private-id
	}





