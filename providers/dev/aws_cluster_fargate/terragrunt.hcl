terraform {
	source = "../../../modules//aws_cluster_fargate"
}

include {
	path = find_in_parent_folders()
}

# for number of runnings
dependencies {
	paths = ["../local_build_init"]
}

dependency "aws_ecr"{
	config_path = "../aws_ecr"
	mock_outputs = {
		ecr_repository_url = "000000000000.dkr.ecr.000000000.amazonaws.com/000000000"
	}
}

inputs = {
	ecr_repository_url = dependency.aws_ecr.outputs.ecr_repository_url
}




