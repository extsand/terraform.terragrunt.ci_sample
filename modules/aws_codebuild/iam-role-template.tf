data "aws_caller_identity" "current_identity" {}
data "aws_region" "current_region" {}


locals {
  # account_id = "530117518858"
  # region     = "eu-central-1"

  account_id = data.aws_caller_identity.current_identity.account_id
  region = data.aws_region.current_region.name
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

data "template_file" "template-for-codebuild-role-policy" {
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:PassRole",
        "iam:ListInstanceProfilesForRole",
        "iam:ListRolePolicies"
      ],
      "Resource": "arn:aws:iam::*:role/*"
    },
    {
      "Action": "iam:CreateServiceLinkedRole",
      "Effect": "Allow",
      "Resource": "arn:aws:iam::*:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS",
      "Condition": {
        "StringLike": {
          "iam:AWSServiceName":"rds.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "rds:*"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*",
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*"       
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:*"
      ],
      "Resource": "arn:aws:secretsmanager:${local.region}:*:secret:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "arn:aws:ssm:${local.region}:*:parameter*"
    },
    {
      "Effect": "Allow",
      "Action" : [
        "dynamodb:*" 
      ],
      "Resource": "*" 
    },
    {
      "Effect": "Allow",
      "Action": [
          "elasticache:*"

      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeAvailabilityZones",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DescribeTags",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "arn:aws:ec2:${local.region}:*:network-interface/*",
      "Condition": {
        "StringLike": {
          "ec2:Subnet": [
            "arn:aws:ec2:${local.region}:*:subnet/*"
          ],
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:DescribeScalingActivities",
          "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:RegisterScalableTarget",
          "appmesh:DescribeVirtualGateway",
          "appmesh:DescribeVirtualNode",
          "appmesh:ListMeshes",
          "appmesh:ListVirtualGateways",
          "appmesh:ListVirtualNodes",
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DeleteLaunchConfiguration",
          "autoscaling:Describe*",
          "autoscaling:UpdateAutoScalingGroup",
          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStack*",
          "cloudformation:UpdateStack",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:PutMetricAlarm",
          "codedeploy:BatchGetApplicationRevisions",
          "codedeploy:BatchGetApplications",
          "codedeploy:BatchGetDeploymentGroups",
          "codedeploy:BatchGetDeployments",
          "codedeploy:ContinueDeployment",
          "codedeploy:CreateApplication",
          "codedeploy:CreateDeployment",
          "codedeploy:CreateDeploymentGroup",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetDeploymentGroup",
          "codedeploy:GetDeploymentTarget",
          "codedeploy:ListApplicationRevisions",
          "codedeploy:ListApplications",
          "codedeploy:ListDeploymentConfigs",
          "codedeploy:ListDeploymentGroups",
          "codedeploy:ListDeployments",
          "codedeploy:ListDeploymentTargets",
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:StopDeployment",
          "ec2:AssociateRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CancelSpotFleetRequests",
          "ec2:CreateInternetGateway",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateVpc",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:Describe*",
          "ec2:DetachInternetGateway",
          "ec2:DisassociateRouteTable",
          "ec2:ModifySubnetAttribute",
          "ec2:ModifyVpcAttribute",
          "ec2:RequestSpotFleet",
          "ec2:RunInstances",
          "ecs:*",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "events:DeleteRule",
          "events:DescribeRule",
          "events:ListRuleNamesByTarget",
          "events:ListTargetsByRule",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets",
          "fsx:DescribeFileSystems",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfiles",
          "iam:ListRoles",
          "lambda:ListFunctions",
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:FilterLogEvents",
          "route53:CreateHostedZone",
          "route53:DeleteHostedZone",
          "route53:GetHealthCheck",
          "route53:GetHostedZone",
          "route53:ListHostedZonesByName",
          "servicediscovery:CreatePrivateDnsNamespace",
          "servicediscovery:CreateService",
          "servicediscovery:DeleteService",
          "servicediscovery:GetNamespace",
          "servicediscovery:GetOperation",
          "servicediscovery:GetService",
          "servicediscovery:ListNamespaces",
          "servicediscovery:ListServices",
          "servicediscovery:UpdateService",
          "sns:ListTopics"
      ],
      "Resource": [
          "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/aws/service/ecs*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "ec2:DeleteInternetGateway",
          "ec2:DeleteRoute",
          "ec2:DeleteRouteTable",
          "ec2:DeleteSecurityGroup"
      ],
      "Resource": [
          "*"
      ],
      "Condition": {
          "StringLike": {
              "ec2:ResourceTag/aws:cloudformation:stack-name": "EC2ContainerService-*"
          }
      }
    },
    {
      "Action": "iam:PassRole",
      "Effect": "Allow",
      "Resource": [
          "*"
      ],
      "Condition": {
          "StringLike": {
              "iam:PassedToService": "ecs-tasks.amazonaws.com"
          }
      }
    },
    {
      "Action": "iam:PassRole",
      "Effect": "Allow",
      "Resource": [
          "arn:aws:iam::*:role/ecsInstanceRole*"
      ],
      "Condition": {
          "StringLike": {
              "iam:PassedToService": [
                  "ec2.amazonaws.com",
                  "ec2.amazonaws.com.cn"
              ]
          }
      }
    },
    {
      "Action": "iam:PassRole",
      "Effect": "Allow",
      "Resource": [
          "arn:aws:iam::*:role/ecsAutoscaleRole*"
      ],
      "Condition": {
          "StringLike": {
              "iam:PassedToService": [
                  "application-autoscaling.amazonaws.com",
                  "application-autoscaling.amazonaws.com.cn"
              ]
          }
      }
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
          "StringLike": {
              "iam:AWSServiceName": [
                  "autoscaling.amazonaws.com",
                  "ecs.amazonaws.com",
                  "ecs.application-autoscaling.amazonaws.com",
                  "spot.amazonaws.com",
                  "spotfleet.amazonaws.com"
              ]
          }
      }
    }
  ]
}
EOF
}
