resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "${local.name_generator}-codebuild-bucket"
  acl    = "private"
	#create version of file
	versioning {
		enabled = true
	}
	#protect from destroy
	# lifecycle {
	# 	prevent_destroy = true
	# }
	
	#possibility for destroying S3 with file inside
	force_destroy = true
	tags = merge(var.project_tags, {Name = "${local.name_generator}-codebuild-bucket"})

}