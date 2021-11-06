terraform {
	source = "../../../modules//local_build_init"
}

include {
	path = find_in_parent_folders()
}

dependency "aws_ecr"{
	config_path = "../aws_ecr"
	skip_outputs = true
}

# dependency "fixme"{
# 	config_path = "../dev"
# 	mock_outputs = {
# 		build_app_command = "00000000"
# 	}
# }

inputs = {
	working_dir = format("%s/../../../app", get_terragrunt_dir())
	# build_app_command  = dependency.dev.outputs.build_app_command
}

