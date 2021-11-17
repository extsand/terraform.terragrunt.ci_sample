resource "aws_iam_role" "codebuild-role" {
	name = "role-for-codebuild"
	assume_role_policy = data.template_file.template-codebuild-role.rendered	
}
resource "aws_iam_role_policy_attachment" "aws_codebuild_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_role_policy_attachment" "aws_cloudwatch_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_iam_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_key_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
}
resource "aws_iam_role_policy_attachment" "aws_s3_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_ec2_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_vpc_admin"{
    role = aws_iam_role.codebuild-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}




# resource "aws_iam_role_policy" "codebuild-role-policy" {
# 	name = "policy-for-role-codebuild"
# 	role = aws_iam_role.codebuild-role.name
# 	policy = data.template_file.v2_template-codebuild-role-policy.rendered
# }