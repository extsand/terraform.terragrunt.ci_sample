provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_codebuild_project" "codebuild" {
  depends_on = [
    aws_codebuild_source_credential.github_token
  ]
  name          = "${local.name_generator}-codebuild"
  description   = "academy codebuild example"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }
  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_bucket.bucket
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  # environment_variable {
  # 	name  = "some-key"
  # 	value = "example-environment-variable-value"
  # }

  #Logs
  logs_config {
    cloudwatch_logs {
      group_name  = "${local.name_generator}-codebuild-group"
      stream_name = "${local.name_generator}-log-codebuild-stream"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.id}/build-log"
    }
  }

  source {
    #main from github
    buildspec = var.buildspec
    type                = "GITHUB"
    location            = var.repo_url
    git_clone_depth     = 1
    report_build_status = true
    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = var.branch_pattern


  vpc_config {
		vpc_id = var.vpc-cluster-id
    # vpc_id = aws_vpc.codebuild_vpc.id
    # subnets = [ 
    # 	aws_subnet.private.*.id
    # 	# aws_subnet.public_a.id,
    # 	# aws_subnet.public_b.id
    # ]
    # subnets = aws_subnet.private.*.id
    
		subnets = var.private-subnets

    security_group_ids = [
      aws_security_group.security_for_codebuild.id
    ]
  }
  tags = merge(var.project_tags, {Name = "${local.name_generator}-codebuild"})
}


