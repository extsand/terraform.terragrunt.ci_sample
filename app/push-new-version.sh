#!/bin/bash

echo 'Push new version'
echo 'version:'$1
make build-app APP_TAG=$1


# APP_NAME ?= blue-app
# ENV_NAME ?= dev
# APP_TAG ?= init