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

inputs = {
	working_dir = format("%s/../../app", get_terragrunt_dir())
}
