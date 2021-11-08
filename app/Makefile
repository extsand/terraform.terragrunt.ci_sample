# More about Makefile
# https://guides.hexlet.io/makefile-as-task-runner/
# https://makefiletutorial.com/
# 

#VAR = value - required variable
#VAR ?= value - optional variable
# you can set optional var like arg 
## example: 
## make build-app APP_NAME=example

#app variables
APP_NAME ?= academy-app
ENV_NAME ?= dev
APP_TAG ?= init
APP_IMAGE = $(AWS_REPOSITORY_NAME):$(APP_TAG)

#aws variables
AWS_REGISTRY_ID ?= 530117518858
AWS_REPOSITORY_REGION ?= eu-central-1
AWS_PROFILE ?= academy
AWS_REPOSITORY_NAME = $(AWS_REGISTRY_ID).dkr.ecr.$(AWS_REPOSITORY_REGION).amazonaws.com/$(APP_NAME)-$(ENV_NAME)



#Set tasks:
#Using .PHONY for cover collision with Task names and File/folder names


#Task name: build-app
# - create docker image 
# - push docker image to aws elastic container registry
.PHONY:build-app
build-app:
	echo "Login aws ecr"
	$(MAKE) aws-ecr-login

	echo "Build task started"
	# docker build -t $(APP_IMAGE) -f ./app/Dockerfile .
	# docker build -t $(APP_IMAGE) -f ./app/Dockerfile
	
	docker build -t $(APP_IMAGE) ./app/.
	docker push $(APP_IMAGE)
	echo "------ All task is done -------"

#Task name: aws-ecr-login 
# - log in to aws elastic container registry
# - for more about - read AWS CLI info
.PHONY:aws-ecr-login 
aws-ecr-login: 
	aws ecr get-login-password --region=$(AWS_REPOSITORY_REGION) --profile $(AWS_PROFILE) | docker login --username AWS --password-stdin $(AWS_REGISTRY_ID).dkr.ecr.$(AWS_REPOSITORY_REGION).amazonaws.com

.PHONY:debug-mode
debug-mode:
	echo "Debug mode ON ============= YOU WILL CHANGE MAKE TASK! "