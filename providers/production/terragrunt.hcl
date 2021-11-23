# for fix error with terragrunt cache 
# add new env var to OS
# export TERRAGRUNT_DOWNLOAD=C:\.terragrunt-cache
# all variables set like TF_VAR_variable="myfirstvar"
# TF_VAR_instance_type="t2.micro" \
# TF_VAR_instance_count=10 \
# TF_VAR_tags='{"Name":"example-app"}' \

locals {
	#aws account
	aws_profile = "academy"
	aws_account = "530117518858"
	aws_region = "eu-west-3"
	aws_az_count = "2"
	
	#aws bucket
	remote_state_bucket_prefix = "terraform"
	env = "production"	
	
	#app settings
	app_name = "academy-app"
	app_port = "80"
	app_count = 2
	image_tag = "init"
	build_app_command = "make build-app APP_NAME=${local.app_name} ENV_NAME=${local.env} APP_TAG=${local.image_tag}"
	

	#repo settings
	repo_url = "https://github.com/extsand/terraform.terragrunt.ci_sample.git"
	repo_branch = "dev-fargate"
	branch_pattern = "^refs/heads/${local.repo_branch}$"
	git_trigger_event = "PUSH"

	buildspec = "./providers/${local.env}/buildspec.yml"
	# app/buildspec.yml

	


	#project tags
	project_tags = {
		"project" = "DevOps Academy Example"
		"owner" = "extsand"
	}

	#fargate settings
	fargate_cpu = "512"
	fargate_memory = "1024"

}

# Indicate the input values to use for the variables of the module.
#=====================================================================
inputs = {
	remote_state_bucket = format("%s-%s-%s-%s", local.remote_state_bucket_prefix, local.app_name, local.env, local.aws_region)
	environment = local.env

	aws_profile = local.aws_profile
	aws_account = local.aws_account
	aws_region = local.aws_region
	aws_az_count = local.aws_az_count

	app_name = local.app_name
	app_port = local.app_port
	app_count = local.app_count
	app_tag = local.image_tag
	build_app_command = local.build_app_command
	# app_working_dir = local.app_working_dir


	repo_url = local.repo_url
	repo_branch = local.repo_branch
	branch_pattern = local.branch_pattern
	git_trigger_event = local.git_trigger_event

	buildspec = local.buildspec

	project_tags = local.project_tags

	fargate_cpu = local.fargate_cpu
	fargate_memory = local.fargate_memory

}

remote_state {
	backend = "s3"
	config = {
		profile = local.aws_profile
		region = local.aws_region
		
		bucket = format("%s-%s-%s-%s", local.remote_state_bucket_prefix, local.app_name, local.env, local.aws_region)
		key = format("%s/terraform.tfstate", path_relative_to_include())
		dynamodb_table = format("tflock-%s-%s-%s", local.env, local.app_name, local.aws_region)
		encrypt = true
	}
}

#S3 versioning
generate "tfenv" {
  path              = ".terraform-version"
  if_exists         = "overwrite"
  disable_signature = true

  contents = <<EOF
1.0.4
EOF
}

#How Terragrunt will interact with Terraform
terraform {
  after_hook "remove_lock" {
    commands = [
      "apply",
      "console",
      "destroy",
      "import",
      "init",
      "plan",
      "push",
      "refresh",
    ]

    execute = [
      "rm",
      "-f",
      "${get_terragrunt_dir()}/.terraform.lock.hcl",
    ]

    run_on_error = true
  }
}


#My current version
# terraform v1.0.4
# terragrunt v0.35.4

#Set version for terraform and terragrunt
terraform_version_constraint = ">=1.0.4"
terragrunt_version_constraint = ">= 0.35.4"
