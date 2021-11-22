#!/bin/bash
# get info about aws profile
aws sts get-caller-identity

CLUSTER_NAME="some"
SERVICE_ARN="arn"
TASK_DEF="definition"

aws ecs list-services --cluster $CLUSTER_NAME
aws ecs describe-services --cluster $CLUSTER_NAME --service $SERVICE_ARN
aws ecs describe-task-definition --task-definition $TASK_DEF 

