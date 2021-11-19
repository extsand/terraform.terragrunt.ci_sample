variable "git_token" {}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "for-codebuild"
  acl    = "private"
}





resource "aws_codebuild_project" "best-codebuild-ever" {
  depends_on = [
    aws_codebuild_source_credential.github_token
  ]
  name          = "silver-paper"
  description   = "bla bla bla again"
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
  # 	value = "dsfjslkdjf2113l;ksl;dkfsdf"
  # }

  #Logs
  logs_config {
    cloudwatch_logs {
      group_name  = "log-codebuild-group"
      stream_name = "log-codebuild-stream"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.id}/build-log"
    }
  }

  source {
    #main from github
    buildspec = "hide_buildspec.yml"
    type                = "GITHUB"
    location            = "https://github.com/extsand/blue_app"
    git_clone_depth     = 1
    report_build_status = true
    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "main"


  vpc_config {
    vpc_id = aws_vpc.codebuild_vpc.id
    # subnets = [ 
    # 	aws_subnet.private.*.id
    # 	# aws_subnet.public_a.id,
    # 	# aws_subnet.public_b.id
    # ]
    subnets = aws_subnet.private.*.id

    security_group_ids = [
      aws_security_group.security_for_codebuild.id
    ]
  }
  tags = {
    Environment = "Test test test"
  }
}


