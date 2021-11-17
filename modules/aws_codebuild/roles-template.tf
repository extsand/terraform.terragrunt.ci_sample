locals {
	account_id = "530117518858"
	region = "eu-central-1"
}



data "template_file" "template-codebuild-role" {
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}










# data "template_file" "template-codebuild-role-policy" {
#   template = <<POLICY
# {
#    "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Resource": [
#         "*"
#       ],
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ]
#     },    
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:*"
#       ],
#       "Resource": [
#         "${aws_s3_bucket.codebuild_bucket.arn}",
#         "${aws_s3_bucket.codebuild_bucket.arn}/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:CreateNetworkInterface",
#         "ec2:DescribeDhcpOptions",
#         "ec2:DescribeNetworkInterfaces",
#         "ec2:DeleteNetworkInterface",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeVpcs"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:CreateNetworkInterfacePermission"
#       ],
#       "Resource": "arn:aws:ec2:${local.region}:${local.account_id}:network-interface/*",
#       "Condition": {
#         "StringEquals": {
#           "ec2:AuthorizedService": "codebuild.amazonaws.com"
#         },
#         "ArnEquals": {
#           "ec2:Subnet": [
#             "arn:aws:ec2:${local.region}:${local.account_id}:subnet/*"
#           ]
#         }
#       }
#     }
#   ]
# }
# POLICY
# }


# data "template_file" "v2_template-codebuild-role-policy" {
#   template = <<POLICY
# {
#     "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "iam:CreateRole",
#         "iam:DeleteRole",
#         "iam:PutRolePolicy",
#         "iam:DeleteRolePolicy",
#         "iam:GetRole",
#         "iam:GetRolePolicy",
#         "iam:PassRole",
#         "iam:ListInstanceProfilesForRole",
#         "iam:ListRolePolicies"
#       ],
#       "Resource": "arn:aws:iam::*:role/*"
#     },
#     {
#       "Action": "iam:CreateServiceLinkedRole",
#       "Effect": "Allow",
#       "Resource": "arn:aws:iam::*:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS",
#       "Condition": {
#         "StringLike": {
#           "iam:AWSServiceName":"rds.amazonaws.com"
#         }
#       }
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:*"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "elasticloadbalancing:*"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "rds:*"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect":"Allow",
#       "Action": [
#         "s3:*"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ecr:*",
#         "ecs:*"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "cloudwatch:*"       
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "secretsmanager:*"
#       ],
#       "Resource": "arn:aws:secretsmanager:${local.region}:*:secret:*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ssm:GetParameters"
#       ],
#       "Resource": "arn:aws:ssm:${local.region}:*:parameter*"
#     },
#     {
#       "Effect": "Allow",
#       "Action" : [
#         "dynamodb:*" 
#       ],
#       "Resource": "*" 
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#           "elasticache:*"

#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:AuthorizeSecurityGroupEgress",
#         "ec2:AuthorizeSecurityGroupIngress",
#         "ec2:CreateSecurityGroup",
#         "ec2:DeleteSecurityGroup",
#         "ec2:RevokeSecurityGroupEgress",
#         "ec2:RevokeSecurityGroupIngress",
#         "ec2:DeleteNetworkInterface",
#         "ec2:DescribeNetworkInterfaces",
#         "ec2:DescribeAvailabilityZones",
#         "ec2:CreateNetworkInterface",
#         "ec2:DescribeDhcpOptions",
#         "ec2:CreateTags",
#         "ec2:DeleteTags",
#         "ec2:DescribeTags",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeVpcs"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:CreateNetworkInterfacePermission"
#       ],
#       "Resource": "arn:aws:ec2:${local.region}:*:network-interface/*",
#       "Condition": {
#         "StringLike": {
#           "ec2:Subnet": [
#             "arn:aws:ec2:${local.region}:*:subnet/*"
#           ],
#           "ec2:AuthorizedService": "codebuild.amazonaws.com"
#         }
#       }
#     }
#   ]
# }
# POLICY
# }
