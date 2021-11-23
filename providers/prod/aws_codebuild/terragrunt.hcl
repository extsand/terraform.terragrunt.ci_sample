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
		#grab data from aws_cluster_outputs
		vpc_id = "vpc-0000"
		subnets-private-id = ["subnet-0000", "subnet-0001"]
	}

}

inputs = {
		vpc_cluster_id = dependency.aws_cluster_fargate.outputs.vpc_id
		private_subnets = dependency.aws_cluster_fargate.outputs.subnets-private-id
		# for debug mode
		# buffer-value = dependency.aws_cluster_fargate.outputs.subnets-private-id
	}





