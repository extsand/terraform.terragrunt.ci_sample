# #add credentials for github
resource "aws_codebuild_source_credential" "github_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.git_token
}


# # ======== Manual version
# resource "null_resource" "import_credentials" {
# 	triggers = {
# 		github_oauth_token = var.git_token
# 	}
# 	provisioner "local-exec" {
# 		command = <<EOF
# 		 aws --region eu-central-1 codebuild import-source-credentials \
#                                                              --token ${var.git_token} \
#                                                              --server-type GITHUB \
#                                                              --auth-type PERSONAL_ACCESS_TOKEN
# EOF
# 	}
# }

