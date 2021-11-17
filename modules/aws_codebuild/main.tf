provider "aws" {
	profile = "default"
	region = "eu-central-1"
}

resource "aws_s3_bucket" "codebuild_bucket" {
	bucket = "for-codebuild"
	acl = "private"
}

resource "aws_iam_role" "codebuild-role" {
	name = "role-for-codebuild"
	assume_role_policy = data.template_file.template-codebuild-role.rendered	
}

resource "aws_iam_role_policy" "codebuild-role-policy" {
	name = "policy-for-role-codebuild"
	role = aws_iam_role.codebuild-role.name
	policy = data.template_file.template-codebuild-role-policy.rendered
}

resource "null_resource" "import_credentials" {
	triggers = {
		github_oauth_tocken = "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"
	}
	provisioner "local-exec" {
		command = <<EOF
		 aws --region eu-central-1 codebuild import-source-credentials \
                                                             --token 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 \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
	}
}

resource "aws_codebuild_project" "best-codebuild-ever" {
	depends_on = [
		null_resource.import_credentials
	]
	name = "golden-paper"
	description = "bla bla bla again"
	build_timeout = "10"
	service_role = aws_iam_role.codebuild-role.arn

	artifacts {
		type = "NO_ARTIFACTS"
	}
	cache {
		type = "S3"
		location = aws_s3_bucket.codebuild_bucket.bucket
	}
	environment {
		compute_type = "BUILD_GENERAL1_SMALL"
		image = "aws/codebuild/standard:4.0"
		type = "LINUX_CONTAINER"
		image_pull_credentials_type = "CODEBUILD"
		privileged_mode = true
	}

	# environment_variable {
	# 	name  = "some-key"
	# 	value = "dsfjslkdjf2113l;ksl;dkfsdf"
	# }

	#Logs
	logs_config {
		cloudwatch_logs {
			group_name = "log-codebuild-group"
			stream_name = "log-codebuild-stream"
		}
		s3_logs {
			status = "ENABLED"
			location = "${aws_s3_bucket.codebuild_bucket.id}/build-log"
		}
	}

	source {
		buildspec = "./buildspec.yml"
		type = "GITHUB"
		location = "https://github.com/extsand/blue_app"
		git_clone_depth = 1
		report_build_status = true
		git_submodules_config {
			fetch_submodules = true
		}
	}
	source_version = "main"


	vpc_config {
		vpc_id = aws_vpc.codebuild_vpc.id
		subnets = [ 
			aws_subnet.public_a.id,
			aws_subnet.public_b.id
		]
		security_group_ids = [
			aws_security_group.security_for_codebuild.id
		]
	}
	tags = {
		Environment = "Test test test"
	}




}

