# JSON Parser
# more https://stedolan.github.io/jq/tutorial/
# more http://www.compciv.org/recipes/cli/jq-for-parsing-json/
APP_NAME="blue-app" 
ENV_NAME="developer-mode"
APP_TAG="latest"
AWS_REPOSITORY_REGION="eu-central-1"

VERSION_FROM_GIT="${CODEBUILD_RESOLVED_SOURCE_VERSION}"
DIR="${CODEBUILD_SRC_DIR}"
    
TERRAFORM_VERSION="1.0.10"
TERRAGRUNT_VERSION="0.35.6"

sudo apt  install jq

#example
aws sts get-caller-identity 

aws sts get-caller-identity | jq
aws sts get-caller-identity | jq -r '.UserId'
aws sts get-caller-identity | jq -r '.Account'


export AWS_REGISTRY_ID=`aws sts get-caller-identity | jq -r '.UserId'`
export AWS_REPOSITORY_NAME=`$(AWS_REGISTRY_ID).dkr.ecr.$(AWS_REPOSITORY_REGION).amazonaws.com/$(APP_NAME)-$(ENV_NAME)`

env | grep "AWS"

