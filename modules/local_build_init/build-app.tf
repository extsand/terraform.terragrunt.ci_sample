#create container application 
#with null_resource

resource "null_resource" "build_app" {
	provisioner "local-exec" {
		command = var.build_app_command
		working_dir = var.working_dir
		environment = {

			AWS_REGISTRY_ID = data.aws_caller_identity.current.account_id
			AWS_REPOSITORY_REGION = var.aws_region
			AWS_PROFILE = var.aws_profile

			APP_NAME = var.app_name
			APP_TAG = var.app_tag
			ENV_NAME = var.env
		}
	}
}