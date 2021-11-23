terraform {
	source = "../../../modules//aws_ecr"
}

include {
	path = find_in_parent_folders()
}