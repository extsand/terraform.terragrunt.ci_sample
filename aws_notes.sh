#!/bin/bash
# get info about aws profile
aws sts get-caller-identity
aws configure list [--profile profile-name]

aws configure list
aws sts get-caller-identity

CLUSTER_NAME="some"
SERVICE_ARN="arn"
TASK_DEF="definition"

aws ecs list-services --cluster $CLUSTER_NAME
aws ecs describe-services --cluster $CLUSTER_NAME --service $SERVICE_ARN
aws ecs describe-task-definition --task-definition $TASK_DEF 

aws elbv2 describe-load-balancers 
aws elbv2 describe-load-balancers | jq -r '.LoadBalancers[].DNSName'