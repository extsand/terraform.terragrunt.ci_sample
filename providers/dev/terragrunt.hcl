# for fix error with terragrunt cache 
# add new env var to OS
# export TERRAGRUNT_DOWNLOAD=C:\.terragrunt-cache

locals {
	#aws account
	aws_profile = "default"
	aws_account = "530117518858"
	aws_region = "eu-central-1"
	
	#aws bucket
	remote_state_bucket_prefix = "terraform"
	env = "dev"	
	
	#app settings
	app_name = "golden-app"
	app_count = 1
	image_tag = "0.1"
	build_app_command = "make build-app"
	# app_working_dir = "../../some_homies"

  #repo settings
	repo_url = "https://git......."
	repo_branch = "dev"
	branch_pattern = "^refs/heads/${local.repo_branch}$"
	git_trigger_event = "PUSH"
}

# Indicate the input values to use for the variables of the module.
#=====================================================================
inputs = {
	remote_state_bucket = format("%s-%s-%s-%s", local.remote_state_bucket_prefix, local.app_name, local.env, local.aws_region)
	environment = local.env

	aws_profile = local.aws_profile
	aws_account = local.aws_account
	aws_region = local.aws_region

	app_name = local.app_name
	app_count = local.app_count
	image_tag = local.image_tag
	build_app_command = local.build_app_command
	# app_working_dir = local.app_working_dir

	app_name = local.app_name
	app_count = local.app_count
	image_tag = local.image_tag

	repo_url = local.repo_url
	repo_branch = local.repo_branch
	branch_pattern = local.branch_pattern
	git_trigger_event = local.git_trigger_event

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
